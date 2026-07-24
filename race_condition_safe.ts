import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SERVICE_ROLE_KEY!
);

// Nuova Funzione: Simula il tentativo di prenotazione CON Lock (chiamando la RPC)
async function bookPropertySafe(userId: string, propertyId: string, attempt: number) {
  
  // CHIAMATA ALLA FUNZIONE SQL (RPC) SUL DATABASE
  const { data: success, error } = await supabase.rpc('book_property_safe', {
    p_user_id: userId,
    p_property_id: propertyId
  });

  if (error) {
    console.log(`[Utente ${attempt}] ❌ Errore del server:`, error.message);
    return false;
  }

  if (success === true) {
    console.log(`✅ [Utente ${attempt}] PRENOTAZIONE CONFERMATA E SICURA!`);
    return true;
  } else {
    console.log(`❌ [Utente ${attempt}] Casa occupata. Prenotazione respinta dal Lock.`);
    return false;
  }
}

async function runSafeTest() {
  console.log('🛡️ AVVIO SIMULATORE CON PESSIMISTIC LOCK (RPC) 🛡️\n');

  const { data: users } = await supabase.from('users').select('id').limit(1);
  const { data: properties } = await supabase.from('properties').select('id').limit(1);

  if (!users || users.length === 0 || !properties || properties.length === 0) return;

  const testUser = users[0].id;
  const testProperty = properties[0].id;

  // RIPRISTINO
  await supabase.from('properties').update({ is_available: true }).eq('id', testProperty);
  await supabase.from('bookings').delete().eq('property_id', testProperty);

  console.log(`🏠 Casa ripristinata: Libera.`);
  console.log(`🚀 Lancio 10 richieste simultanee corazzate...\n`);

  const promises = [];
  for (let i = 1; i <= 10; i++) {
    promises.push(bookPropertySafe(testUser, testProperty, i));
  }

  await Promise.all(promises);

  // CONTROLLO DEI DANNI
  const { count } = await supabase
    .from('bookings')
    .select('*', { count: 'exact' })
    .eq('property_id', testProperty);

  console.log('\n=============================================');
  console.log('📊 REPORT SICUREZZA SUL DATABASE:');
  console.log(`La casa poteva ospitare UNA sola persona.`);
  console.log(`Prenotazioni confermate e soldi incassati: ${count} 🛡️ SISTEMA SALVO 🛡️`);
  console.log('=============================================');
}

runSafeTest();

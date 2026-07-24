import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

dotenv.config();

// Usiamo la Service Role Key perché questo codice simula il nostro Backend Node.js
const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SERVICE_ROLE_KEY!
);

// Funzione che simula il tentativo di prenotazione SENZA Lock
async function bookPropertyVulnerable(userId: string, propertyId: string, attempt: number) {
  // 1. Leggo dal database se la casa è libera
  const { data: property, error: readError } = await supabase
    .from('properties')
    .select('is_available')
    .eq('id', propertyId)
    .single();

  if (readError) throw readError;

  // Se è libera...
  if (property.is_available === true) {
    console.log(`[Utente ${attempt}] Vede la casa libera! Avvio il pagamento...`);

    // SIMULAZIONE LATENZA DI RETE (Es. contatto Stripe per pagare).
    // Ci metto 200 millisecondi. Nel frattempo il DB è esposto.
    await new Promise((resolve) => setTimeout(resolve, 200));

    // 2. Cambio lo stato della casa in "occupata"
    await supabase
      .from('properties')
      .update({ is_available: false })
      .eq('id', propertyId);

    // 3. Emetto la ricevuta (Inserisco la prenotazione)
    await supabase
      .from('bookings')
      .insert({
        user_id: userId,
        property_id: propertyId,
        price: 15000, // 150 euro
        check_in_date: '2026-08-01',
        check_out_date: '2026-08-10'
      });

    console.log(`✅ [Utente ${attempt}] PRENOTAZIONE CONFERMATA!`);
    return true;
  } else {
    console.log(`❌ [Utente ${attempt}] Casa occupata. Prenotazione rifiutata.`);
    return false;
  }
}

// Funzione Principale: Il Crash Test
async function runCrashTest() {
  console.log('🔥 AVVIO SIMULATORE RACE CONDITION 🔥\n');

  // Recupero il primo utente e la prima casa dal tuo DB per fare il test
  const { data: users } = await supabase.from('users').select('id').limit(1);
  const { data: properties } = await supabase.from('properties').select('id').limit(1);

  if (!users || users.length === 0 || !properties || properties.length === 0) {
    console.log('ERRORE: Assicurati di avere almeno 1 Utente e 1 Casa nel database.');
    return;
  }

  const testUser = users[0].id;
  const testProperty = properties[0].id;

  // RIPRISTINO IL CAMPO DI BATTAGLIA: Imposto la casa come Libera e cancello vecchie prenotazioni
  await supabase.from('properties').update({ is_available: true }).eq('id', testProperty);
  await supabase.from('bookings').delete().eq('property_id', testProperty);

  console.log(`🏠 Casa ripristinata: Libera.`);
  console.log(`🚀 Lancio 10 richieste simultanee nello stesso millisecondo...\n`);

  // Creo un array di 10 promesse in esecuzione simultanea (Tutti premono il tasto insieme)
  const promises = [];
  for (let i = 1; i <= 10; i++) {
    promises.push(bookPropertyVulnerable(testUser, testProperty, i));
  }

  // Eseguo tutte le 10 richieste contemporaneamente
  await Promise.all(promises);

  // CONTROLLO DEI DANNI
  const { count } = await supabase
    .from('bookings')
    .select('*', { count: 'exact' })
    .eq('property_id', testProperty);

  console.log('\n=============================================');
  console.log('📊 REPORT DEI DANNI SUL DATABASE:');
  console.log(`La casa poteva ospitare UNA sola persona.`);
  console.log(`Prenotazioni confermate e soldi incassati: ${count} 💥 DISASTRO 💥`);
  console.log('=============================================');
}

runCrashTest();

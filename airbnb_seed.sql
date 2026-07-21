-- ==========================================
-- AIRBNB CLONE - SEED DATA SCRIPT
-- Esegui questo script DOPO aver creato le tabelle in Supabase.
-- ==========================================

-- 1. USERS (15 Utenti: alcuni diventeranno Host, altri Guest, altri non faranno nulla)
INSERT INTO users (id, email, hashed_password, username, phone_number, created_at) VALUES
('aaaa0000-0000-0000-0000-000000000001', 'host.roma@email.it', 'hash1', 'host_roma', '+393331111111', '2023-01-01 10:00:00'),
('aaaa0000-0000-0000-0000-000000000002', 'host.milano@email.it', 'hash2', 'host_milano', '+393332222222', '2023-02-15 11:30:00'),
('aaaa0000-0000-0000-0000-000000000003', 'host.napoli@email.it', 'hash3', 'host_napoli', '+393333333333', '2023-03-20 09:15:00'),
('aaaa0000-0000-0000-0000-000000000004', 'host.sfigato@email.it', 'hash4', 'host_zero_clienti', '+393334444444', '2024-01-10 14:00:00'),
('aaaa0000-0000-0000-0000-000000000005', 'viaggiatore.ricco@email.it', 'hash5', 'mr_money', '+393335555555', '2023-05-10 16:45:00'),
('aaaa0000-0000-0000-0000-000000000006', 'viaggiatore.seriale@email.it', 'hash6', 'travel_addict', '+393336666666', '2023-06-11 10:20:00'),
('aaaa0000-0000-0000-0000-000000000007', 'viaggiatore.normale@email.it', 'hash7', 'normal_guy', '+393337777777', '2023-07-22 18:30:00'),
('aaaa0000-0000-0000-0000-000000000008', 'viaggiatore.fantasma@email.it', 'hash8', 'ghost_user', '+393338888888', '2024-05-01 20:00:00'),
('aaaa0000-0000-0000-0000-000000000009', 'luca.bianchi@email.it', 'hash9', 'lucab', '+393339999999', '2024-02-14 12:00:00'),
('aaaa0000-0000-0000-0000-000000000010', 'marta.verdi@email.it', 'hash10', 'martav', '+393331010101', '2024-03-08 08:00:00');

-- 2. HOST PROFILES (Solo gli utenti da 1 a 4 diventano Host)
INSERT INTO hosts (id, user_id, iban, partita_iva) VALUES
('bbbb0000-0000-0000-0000-000000000001', 'aaaa0000-0000-0000-0000-000000000001', 'IT11ROMA0000', 'PIVA_ROMA123'),
('bbbb0000-0000-0000-0000-000000000002', 'aaaa0000-0000-0000-0000-000000000002', 'IT22MILA0000', 'PIVA_MILA456'),
('bbbb0000-0000-0000-0000-000000000003', 'aaaa0000-0000-0000-0000-000000000003', 'IT33NAPO0000', 'PIVA_NAPO789'),
('bbbb0000-0000-0000-0000-000000000004', 'aaaa0000-0000-0000-0000-000000000004', 'IT44SFIG0000', 'PIVA_SFIG000');

-- 3. PROPERTIES (Case)
-- L'Host 1 ha 3 case. L'Host 2 ha 2 case lusso. L'Host 3 ha 1 casa. L'Host 4 ha 1 casa sfigata.
INSERT INTO properties (id, host_id, title, description, location) VALUES
('cccc0000-0000-0000-0000-000000000001', 'bbbb0000-0000-0000-0000-000000000001', 'Attico Colosseo', 'Vista mozzafiato sul Colosseo.', 'Roma Centro'),
('cccc0000-0000-0000-0000-000000000002', 'bbbb0000-0000-0000-0000-000000000001', 'Stanza Trastevere', 'Piccola ma accogliente.', 'Roma Trastevere'),
('cccc0000-0000-0000-0000-000000000003', 'bbbb0000-0000-0000-0000-000000000001', 'Monolocale Parioli', 'Zona residenziale tranquilla.', 'Roma Nord'),
('cccc0000-0000-0000-0000-000000000004', 'bbbb0000-0000-0000-0000-000000000002', 'Loft Duomo', 'Lusso sfrenato a due passi dal Duomo.', 'Milano Centro'),
('cccc0000-0000-0000-0000-000000000005', 'bbbb0000-0000-0000-0000-000000000002', 'Villa Navigli', 'Party house sui Navigli.', 'Milano Navigli'),
('cccc0000-0000-0000-0000-000000000006', 'bbbb0000-0000-0000-0000-000000000003', 'Appartamento Spaccanapoli', 'Vera esperienza napoletana.', 'Napoli Centro Storico'),
('cccc0000-0000-0000-0000-000000000007', 'bbbb0000-0000-0000-0000-000000000004', 'Seminterrato Umido', 'Costa poco ma piove dentro.', 'Periferia Sconosciuta');

-- 4. BOOKINGS (Prenotazioni) 
-- Prezzi in centesimi (es. 150000 = 1500.00€)
INSERT INTO bookings (id_booked, user_id, property_id, check_in_date, check_out_date, price, created_at) VALUES
-- Viaggiatore Ricco (Utente 5) prenota le case costose (Proprietà 1 e 4)
('dddd0000-0000-0000-0000-000000000001', 'aaaa0000-0000-0000-0000-000000000005', 'cccc0000-0000-0000-0000-000000000001', '2024-08-01', '2024-08-05', 150000, '2024-01-15 10:00:00'),
('dddd0000-0000-0000-0000-000000000002', 'aaaa0000-0000-0000-0000-000000000005', 'cccc0000-0000-0000-0000-000000000004', '2024-12-20', '2024-12-27', 350000, '2024-02-20 11:00:00'),

-- Viaggiatore Seriale (Utente 6) prenota ovunque (Proprietà 2, 3, 5, 6)
('dddd0000-0000-0000-0000-000000000003', 'aaaa0000-0000-0000-0000-000000000006', 'cccc0000-0000-0000-0000-000000000002', '2024-03-10', '2024-03-12', 12000, '2024-02-01 09:00:00'),
('dddd0000-0000-0000-0000-000000000004', 'aaaa0000-0000-0000-0000-000000000006', 'cccc0000-0000-0000-0000-000000000003', '2024-04-15', '2024-04-18', 18000, '2024-03-01 09:00:00'),
('dddd0000-0000-0000-0000-000000000005', 'aaaa0000-0000-0000-0000-000000000006', 'cccc0000-0000-0000-0000-000000000005', '2024-05-20', '2024-05-22', 80000, '2024-04-01 09:00:00'),
('dddd0000-0000-0000-0000-000000000006', 'aaaa0000-0000-0000-0000-000000000006', 'cccc0000-0000-0000-0000-000000000006', '2024-06-10', '2024-06-17', 45000, '2024-05-01 09:00:00'),

-- Viaggiatore Normale (Utente 7) prenota una volta sola (Proprietà 2)
('dddd0000-0000-0000-0000-000000000007', 'aaaa0000-0000-0000-0000-000000000007', 'cccc0000-0000-0000-0000-000000000002', '2024-09-01', '2024-09-05', 30000, '2024-07-01 10:00:00'),

-- L'Host 1 (Roma) prenota come Guest la casa dell'Host 3 (Napoli) (Proprietà 6)
-- Questo dimostra che un Host può usare lo stesso user_id per viaggiare.
('dddd0000-0000-0000-0000-000000000008', 'aaaa0000-0000-0000-0000-000000000001', 'cccc0000-0000-0000-0000-000000000006', '2024-10-10', '2024-10-15', 35000, '2024-08-01 10:00:00');

-- NOTE PER GLI ESERCIZI:
-- L'utente 8 (Fantasma) non ha prenotazioni. Ottimo per testare LEFT JOIN con NULL.
-- L'Host 4 ("Seminterrato Umido") non ha ricevuto prenotazioni. Ottimo per query di performance.
-- I prezzi sono in centesimi (integer) per forzarti a usare la matematica (es. price / 100) nelle SELECT.

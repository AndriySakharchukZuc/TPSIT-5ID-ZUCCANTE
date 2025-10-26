# Andriy Sakharchuk 5ID Clockstream

Creato 2 stream:
- **ticker** che ritorna un tick (numero intero di 1) ogni secondo
- **orologio** che ascolta il risultato di **ticker** e aggiunge valore che ritorna ticker al suo contatore interno.

Creato enum: 
- **StatoOrologio** con i valori START, STOP e RESET per gestire la subscription e l'icona di **_iconaOrologio1**
  https://github.com/AndriySakharchukZuc/TPSIT-5ID-ZUCCANTE/blob/bdfa7f252476653e6f23566b422d10b3738fe9f3/clockstream/lib/main.dart#L97
# Andriy Sakharchuk 5ID Clockstream

Creato 2 stream:
- **ticker** che ritorna un tick (numero intero di 1) ogni secondo.
- **orologio** che ascolta il risultato di **ticker** e aggiunge valore che ritorna ticker al suo contatore interno.

Creato enum: 
- **StatoOrologio** con i valori START, STOP e RESET per gestire la subscription tramite **\_modificaStatoOrologio1** e l'icona di **_iconaOrologio1**.

Creato gli funzioni per gestire subscription, stato e icona degli bottoni:
- **\_modificaStatoOrologio1** modifica lo stato di orologio.
- **\_modificaStatoPauseResume** gestisce la pausa di clock.
- **\_iconaOrologio1** modifica l'icona di bottone 'Orologio1'.
# Zadanko diario.

## Commit marzo 17.

Creato nuovo progetto Zadanko. Zadanko e' una app multiutente ToDo per gruppi. Idea iniziale e' da implementare auth (JWT), creazione/entrata nei gruppi, creazione dei task, assegnazione dei task ai utenti vari, notifiche push al momento di update/create di task.
Creato prima pagina di login.

## Commit marzo 23

Creato il prototipo di backend in Go (Documentazione in backendforZadanko).

## Commit aprile 20

Finito il progetto. Fatto downgrade di GUI, feature completati:

- auth (JWT)
- creazione/entrata nei gruppi
- creazione dei task

## Bug critico commit 20 aprile

`register_screen.dart` rimasto dal GUI precedente, il bottone di register non funzionava.

## Commit aprile 24

Bug risolto, aggiunto lo screen al startup per modificare il endpoint di server (per evitare il bug di 20 aprile).

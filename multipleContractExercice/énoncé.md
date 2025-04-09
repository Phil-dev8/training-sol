Exercice : Système de Gestion de Bibliothèque
Contexte :
Vous devez créer un système de gestion de bibliothèque décentralisé où les utilisateurs peuvent emprunter et retourner des livres. Le système doit gérer plusieurs types de livres (par exemple, des livres physiques et des livres numériques) et doit permettre aux utilisateurs d'accéder à des fonctionnalités en fonction de leur rôle (par exemple, administrateur ou utilisateur régulier).

Objectifs :
Héritage : Créez une hiérarchie de contrats pour gérer différents types de livres.
Modificateurs : Utilisez des modificateurs pour restreindre l'accès à certaines fonctions en fonction du rôle de l'utilisateur.
Événements : Émettez des événements lorsque des actions importantes se produisent, comme l'emprunt ou le retour d'un livre.
Interfaces : Définissez une interface pour les livres et implémentez-la dans vos contrats de livres.
Fonctionnalités à Implémenter :
Contrat Principal : Library

Gérer l'inventaire des livres.
Permettre aux utilisateurs d'emprunter et de retourner des livres.
Gérer les rôles des utilisateurs (administrateur et utilisateur régulier).
Contrats de Livres :

Book : Contrat de base pour les livres.
PhysicalBook : Hérite de Book et ajoute des fonctionnalités spécifiques aux livres physiques.
EBook : Hérite de Book et ajoute des fonctionnalités spécifiques aux livres numériques.
Interface : IBook

Définir les fonctions communes à tous les types de livres.
Modificateurs :

onlyAdmin : Permettre l'accès uniquement aux administrateurs.
onlyUser : Permettre l'accès uniquement aux utilisateurs réguliers.
Événements :

BookBorrowed : Événement émis lorsqu'un livre est emprunté.
BookReturned : Événement émis lorsqu'un livre est retourné.
Instructions :
Créez les contrats nécessaires en utilisant les concepts mentionnés.
Assurez-vous que les interactions entre les contrats sont bien définies et sécurisées.
Testez votre système pour vous assurer que toutes les fonctionnalités fonctionnent comme prévu.
Cet exercice vous permettra de pratiquer des concepts avancés en Solidity et de comprendre comment structurer un système complexe en utilisant l'héritage et d'autres fonctionnalités du langage.

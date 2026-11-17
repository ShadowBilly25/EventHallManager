# EventHallManager

Application de gestion de salles et de réservations d'événements développée avec Spring Boot.

## Description

EventHallManager est une application web permettant de gérer les salles d'événements, les utilisateurs et les réservations. Elle propose une interface dédiée pour les administrateurs et pour les utilisateurs standards.

## Fonctionnalités

- Gestion des salles
  - ajout, modification et suppression des salles
  - consultation de la liste des salles disponibles
- Gestion des utilisateurs
  - inscription d'un utilisateur
  - gestion des comptes par l'administrateur
  - profil utilisateur et profil administrateur
- Gestion des réservations
  - création, consultation et modification des réservations
  - validation et suivi des réservations
- Tableau de bord
  - dashboard administrateur
  - dashboard utilisateur
- Authentification
  - connexion avec rôles utilisateur et administrateur

## Stack technique

- Java 17
- Spring Boot 3.2
- Spring Web MVC
- Spring Data JPA
- PostgreSQL
- Maven
- JSP / JSTL

## Prérequis

- Java 17 ou plus
- Maven
- PostgreSQL
- pgAdmin (ou un client PostgreSQL)

## Installation et configuration

1. Créer une base de données PostgreSQL nommée `eventhallmanager`.
2. Vérifier que les informations de connexion PostgreSQL dans `Code source/src/main/resources/application.properties` correspondent à votre configuration locale.
3. Ouvrir le terminal dans le dossier `Code source`.
4. Lancer l'application avec la commande :

```bash
mvn spring-boot:run
```

## Accès à l'application

Une fois l'application démarrée, ouvrir dans le navigateur :

```text
http://localhost:8081/login
```

### Comptes de démonstration

Administrateur :
- email : `admin@gmail.com`
- mot de passe : `admin123`

Utilisateur :
- créer un compte depuis la page d'inscription puis se connecter.

## Structure du projet

```text
EventHallManager-main/
├── README.md
├── Captures d'écran/
│   ├── Côté ADMIN/
│   └── Côté USER/
└── Code source/
    ├── src/
    ├── pom.xml
    └── mvnw
```

## Captures d'écran

Le dossier `Captures d'écran` contient des exemples visuels de l'application, notamment :
- page de connexion
- page d'inscription
- dashboard administrateur
- liste des salles
- liste des réservations
- profil utilisateur et administrateur

## Remarques

Le projet a été mis en place pour une gestion simple et fonctionnelle d'une salle d'événements avec un rôle administratif et un rôle utilisateur distinct.

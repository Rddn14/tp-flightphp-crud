-- Création de la base de données
CREATE DATABASE IF NOT EXISTS tp_flight;
USE tp_flight;

-- Table pour l'établissement financier
CREATE TABLE etablissements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    capital_disponible DECIMAL(15,2) NOT NULL DEFAULT 0,
    date_mise_a_jour TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table pour les types de prêts
CREATE TABLE type_pret (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    taux_interet DECIMAL(5,2) NOT NULL, -- taux annuel
    duree_max_mois INT NOT NULL,        -- durée maximale en mois
    montant_min DECIMAL(12,2) NOT NULL,
    montant_max DECIMAL(12,2) NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour les clients
CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telephone VARCHAR(20),
    adresse TEXT,
    date_naissance DATE,
    profession VARCHAR(100),
    revenu_mensuel DECIMAL(10,2),
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour les prêts
CREATE TABLE prets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    type_pret_id INT NOT NULL,
    montant DECIMAL(12,2) NOT NULL,
    duree_mois INT NOT NULL,
    taux_interet DECIMAL(5,2) NOT NULL,
    date_debut DATE NOT NULL,
    statut ENUM('en_attente', 'approuvé', 'rejeté', 'remboursé') DEFAULT 'en_attente',
    montant_restant DECIMAL(12,2) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client(id),
    FOREIGN KEY (type_pret_id) REFERENCES type_pret(id)
);

-- Table pour les transactions de fonds
CREATE TABLE transaction_fond (
    id INT AUTO_INCREMENT PRIMARY KEY,
    etablissement_id INT NOT NULL,
    type_transaction ENUM('depot', 'retrait') NOT NULL,
    montant DECIMAL(15,2) NOT NULL,
    description TEXT,
    date_transaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (etablissement_id) REFERENCES etablissement(id)
);

-- Table pour les remboursements
CREATE TABLE remboursement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pret_id INT NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    date_prevue DATE NOT NULL,
    date_effectue DATE,
    statut ENUM('en_attente', 'paye', 'en_retard') DEFAULT 'en_attente',
    penalite_retard DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (pret_id) REFERENCES pret(id)
);

-- Table pour les utilisateurs du système (administrateurs)
CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    poste ENUM('admin', 'gestionnaire') NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    derniere_connexion TIMESTAMP NULL
);
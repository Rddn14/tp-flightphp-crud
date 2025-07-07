-- Création de la base de données
CREATE DATABASE IF NOT EXISTS gestion_bancaire;
USE gestion_bancaire;

-- Table Établissement Financier
CREATE TABLE EtablissementFinancier (
    EF_id INT AUTO_INCREMENT PRIMARY KEY,
    EF_nom VARCHAR(100) NOT NULL,
    EF_adresse VARCHAR(255) NOT NULL,
    EF_telephone VARCHAR(20) NOT NULL,
    EF_email VARCHAR(100) NOT NULL,
    EF_date_creation DATE NOT NULL,
    EF_statut ENUM('actif', 'inactif') DEFAULT 'actif',
    CONSTRAINT chk_email_ef CHECK (EF_email LIKE '%@%.%')
) ENGINE=InnoDB;

-- Table Fond
CREATE TABLE Fond (
    fond_id INT AUTO_INCREMENT PRIMARY KEY,
    EF_id INT NOT NULL,
    montant DECIMAL(15, 2) NOT NULL,
    date_ajout DATE NOT NULL,
    source VARCHAR(100) NOT NULL,
    statut ENUM('disponible', 'utilise', 'gele') DEFAULT 'disponible',
    FOREIGN KEY (EF_id) REFERENCES EtablissementFinancier(EF_id) ON DELETE CASCADE,
    CONSTRAINT chk_montant_positif CHECK (montant > 0)
) ENGINE=InnoDB;

-- Table TypePret
CREATE TABLE TypePret (
    type_pret_id INT AUTO_INCREMENT PRIMARY KEY,
    EF_id INT NOT NULL,
    nom_type VARCHAR(50) NOT NULL,
    taux_interet DECIMAL(5, 2) NOT NULL,
    taux_penalite DECIMAL(5, 2) DEFAULT 0,
    duree_max INT NOT NULL COMMENT 'Durée maximale en mois',
    montant_min DECIMAL(15, 2) NOT NULL,
    montant_max DECIMAL(15, 2) NOT NULL,
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (EF_id) REFERENCES EtablissementFinancier(EF_id) ON DELETE CASCADE,
    CONSTRAINT chk_taux_positif CHECK (taux_interet >= 0),
    CONSTRAINT chk_duree_positif CHECK (duree_max > 0),
    CONSTRAINT chk_montant_range CHECK (montant_max >= montant_min)
) ENGINE=InnoDB;

-- Table Client
CREATE TABLE Client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    EF_id INT NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    profession VARCHAR(100),
    revenu_mensuel DECIMAL(12, 2),
    score_credit INT,
    date_inscription DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (EF_id) REFERENCES EtablissementFinancier(EF_id) ON DELETE CASCADE,
    CONSTRAINT chk_email_client CHECK (email IS NULL OR email LIKE '%@%.%'),
    CONSTRAINT chk_age CHECK (TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) >= 18)
) ENGINE=InnoDB;

-- Table Pret
CREATE TABLE Pret (
    pret_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    type_pret_id INT NOT NULL,
    EF_id INT NOT NULL,
    montant DECIMAL(15, 2) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    tranche INT NOT NULL COMMENT 'Nombre de tranches de paiement',
    taux_interet DECIMAL(5, 2) NOT NULL,
    statut ENUM('en_attente', 'actif', 'rembourse', 'en_defaut') DEFAULT 'en_attente',
    montant_restant DECIMAL(15, 2) NOT NULL,
    prochain_paiement DATE,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (type_pret_id) REFERENCES TypePret(type_pret_id),
    FOREIGN KEY (EF_id) REFERENCES EtablissementFinancier(EF_id),
    CONSTRAINT chk_montant_pret_positif CHECK (montant > 0),
    CONSTRAINT chk_date_coherence CHECK (date_fin > date_debut),
    CONSTRAINT chk_montant_restant CHECK (montant_restant >= 0),
    CONSTRAINT chk_tranche_positif CHECK (tranche > 0)
) ENGINE=InnoDB;

-- Table Remboursement
CREATE TABLE Remboursement (
    remboursement_id INT AUTO_INCREMENT PRIMARY KEY,
    pret_id INT NOT NULL,
    date_paiement DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    montant DECIMAL(12, 2) NOT NULL,
    montant_principal DECIMAL(12, 2) NOT NULL,
    montant_interet DECIMAL(12, 2) NOT NULL,
    montant_penalite DECIMAL(12, 2) DEFAULT 0,
    mode_paiement ENUM('especes', 'virement', 'cheque', 'carte') NOT NULL,
    reference VARCHAR(50),
    FOREIGN KEY (pret_id) REFERENCES Pret(pret_id) ON DELETE CASCADE,
    CONSTRAINT chk_montants_remboursement CHECK (montant = montant_principal + montant_interet + montant_penalite)
) ENGINE=InnoDB;

-- Création des index
CREATE INDEX idx_pret_client ON Pret(client_id);
CREATE INDEX idx_pret_type ON Pret(type_pret_id);
CREATE INDEX idx_pret_statut ON Pret(statut);
CREATE INDEX idx_remboursement_pret ON Remboursement(pret_id);
CREATE INDEX idx_remboursement_date ON Remboursement(date_paiement);
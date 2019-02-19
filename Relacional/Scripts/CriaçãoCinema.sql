-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Cinema
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Cinema` ;

-- -----------------------------------------------------
-- Schema Cinema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Cinema` DEFAULT CHARACTER SET utf8 ;
USE `Cinema` ;

-- -----------------------------------------------------
-- Table `Cinema`.`Cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Cliente` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Cliente` (
  `NIF` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `Tipo` CHAR NOT NULL,
  PRIMARY KEY (`NIF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Funcionário`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Funcionário` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Funcionário` (
  `idFuncionário` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFuncionário`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Filme`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Filme` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Filme` (
  `idFilme` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Descrição` TEXT NULL,
  `Classificação` DECIMAL(2,1) NULL,
  PRIMARY KEY (`idFilme`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Sala`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Sala` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Sala` (
  `Número_Sala` INT NOT NULL,
  PRIMARY KEY (`Número_Sala`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Lugar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Lugar` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Lugar` (
  `idLugar` INT NOT NULL,
  `Nr_Sala` INT NOT NULL,
  `Número_Cadeira` INT NOT NULL,
  `Fila` CHAR NOT NULL,
  INDEX `fk_Lugar_Sala_idx` (`Nr_Sala` ASC),
  PRIMARY KEY (`idLugar`, `Nr_Sala`),
  CONSTRAINT `fk_Lugar_Sala`
    FOREIGN KEY (`Nr_Sala`)
    REFERENCES `Cinema`.`Sala` (`Número_Sala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Sessão`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Sessão` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Sessão` (
  `idSessão` INT NOT NULL,
  `Preço_Base` DECIMAL(3,2) NOT NULL,
  `Data` DATE NOT NULL,
  `Hora_Início` TIME NOT NULL,
  `Duração` TIME NOT NULL,
  `Nr_Sala` INT NOT NULL,
  `Filme_id` INT NOT NULL,
  PRIMARY KEY (`idSessão`),
  INDEX `fk_Sessão_Sala1_idx` (`Nr_Sala` ASC),
  INDEX `fk_Sessão_Filme1_idx` (`Filme_id` ASC),
  CONSTRAINT `fk_Sessão_Sala1`
    FOREIGN KEY (`Nr_Sala`)
    REFERENCES `Cinema`.`Sala` (`Número_Sala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sessão_Filme1`
    FOREIGN KEY (`Filme_id`)
    REFERENCES `Cinema`.`Filme` (`idFilme`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cinema`.`Bilhete`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cinema`.`Bilhete` ;

CREATE TABLE IF NOT EXISTS `Cinema`.`Bilhete` (
  `idBilhete` INT NOT NULL,
  `Data_Emissão` DATE NOT NULL,
  `Lugar` INT NOT NULL,
  `Preço` DECIMAL(3,2) NOT NULL,
  `Cliente_NIF` INT NOT NULL,
  `Sessão_id` INT NOT NULL,
  `Funcionário_id` INT NOT NULL,
  PRIMARY KEY (`idBilhete`),
  INDEX `fk_Bilhete_Cliente1_idx` (`Cliente_NIF` ASC),
  INDEX `fk_Bilhete_Sessão1_idx` (`Sessão_id` ASC),
  INDEX `fk_Bilhete_Funcionário1_idx` (`Funcionário_id` ASC),
  CONSTRAINT `fk_Bilhete_Cliente1`
    FOREIGN KEY (`Cliente_NIF`)
    REFERENCES `Cinema`.`Cliente` (`NIF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bilhete_Sessão1`
    FOREIGN KEY (`Sessão_id`)
    REFERENCES `Cinema`.`Sessão` (`idSessão`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bilhete_Funcionário1`
    FOREIGN KEY (`Funcionário_id`)
    REFERENCES `Cinema`.`Funcionário` (`idFuncionário`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

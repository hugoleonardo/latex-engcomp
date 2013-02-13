CREATE TABLE Controlador (
  cpf CHAR(11)  NOT NULL,
  matricula NUMBER  NULL,
  endereco VARCHAR(100) NOT NULL,
  nome VARCHAR(50) NULL,
  telefone VARCHAR(15) NULL,
  email VARCHAR(20) NULL,
  anoAdmissao NUMBER  NOT NULL,
  CONSTRAINT pk_controlador PRIMARY KEY(cpf)
);

CREATE TABLE TipoPlanoVoo (
  idTipoPlanoVoo NUMBER  NOT NULL ,
  nome VARCHAR(20) NOT NULL,
  CONSTRAINT pk_tipoPlanoVoo PRIMARY KEY(idTipoPlanoVoo)
);

CREATE TABLE ModeloAeronave (
  idModeloAeronave NUMBER  NOT NULL ,
  modelo VARCHAR(20) NULL,
  peso NUMBER  NULL,
  numPassageiros NUMBER  NULL,
  pesoMax NUMBER  NULL,
  velCruzeiroKm NUMBER  NULL,
  velCruzeiroMach NUMBER  NULL,
  velCruzeiroKnots NUMBER  NULL,
  CONSTRAINT pk_modeloAeronave PRIMARY KEY(idModeloAeronave)
);

CREATE TABLE Aeroportos (
  idAeroporto NUMBER  NOT NULL ,
  codigoICAO CHAR(4) NOT NULL,
  localidade VARCHAR(40) NOT NULL,
  numPistas NUMBER  NULL,
  numPlatEmbarque NUMBER  NULL,
  capacPassAno NUMBER  NULL,
  CONSTRAINT pk_aeroportos PRIMARY KEY(idAeroporto)
);

CREATE TABLE CiaAerea (
  idCiaAerea NUMBER  NOT NULL ,
  codigoANAC VARCHAR(4) NOT NULL,
  nome VARCHAR(30) NOT NULL,
  CONSTRAINT pk_ciaAerea PRIMARY KEY(idCiaAerea)
);

CREATE TABLE Pistas (
  idPistas NUMBER  NOT NULL ,
  idAeroporto NUMBER  NOT NULL,
  extensao NUMBER  NOT NULL,
  CONSTRAINT pk_pistas PRIMARY KEY(idPistas, idAeroporto),
  --INDEX Pistas_FKIndex1(Aeroportos_idAeroporto),
  CONSTRAINT fk_pista_aeroporto FOREIGN KEY (idAeroporto)
    REFERENCES Aeroportos(idAeroporto)
      
      
);

CREATE TABLE Piloto (
  cpf CHAR(11) NOT NULL,
  matricula NUMBER  NOT NULL,
  idCiaAerea NUMBER  NOT NULL,
  codigoANAC VARCHAR(10) NOT NULL,
  endereco VARCHAR(100) NULL,
  nome VARCHAR(50) NULL,
  telefone VARCHAR(15) NULL,
  email VARCHAR(20) NULL,
  horasVoo NUMBER  NOT NULL,
  milhasVoadas NUMBER  NULL,
  CONSTRAINT pk_piloto PRIMARY KEY(cpf),
  --INDEX Piloto_FKCiaAerea(CiaAerea_idCiaAerea),
  CONSTRAINT fk_piloto_ciaAerea FOREIGN KEY(idCiaAerea)
    REFERENCES CiaAerea(idCiaAerea)
      
      
);

CREATE TABLE Aeronaves (
  numeroSerie VARCHAR(20) NOT NULL,
  idModeloAeronave NUMBER  NOT NULL,
  idCiaAerea NUMBER  NOT NULL,
  matricula VARCHAR(20) NOT NULL,
  CONSTRAINT pk_aeronaves PRIMARY KEY(numeroSerie, idModeloAeronave),
  --INDEX Aeronaves_FKCiaAerea(CiaAerea_idCiaAerea),
  --INDEX Aeronaves_FKIndex2(ModeloAeronaves_idModeloAeronaves),
  CONSTRAINT fk_aeronaves_ciaAerea FOREIGN KEY(idCiaAerea)
    REFERENCES CiaAerea(idCiaAerea),
  CONSTRAINT fk_aeronaves_modelo FOREIGN KEY(idModeloAeronave)
    REFERENCES ModeloAeronave(idModeloAeronave)
      
      
);

CREATE TABLE Escalas (
  idEscalas NUMBER  NOT NULL ,
  idAeroportoOrigem NUMBER  NOT NULL,
  idAeroportoDestino NUMBER  NOT NULL,
  CONSTRAINT pk_escalas PRIMARY KEY(idEscalas),
  --INDEX Escalas_FKAeroportoOrigem(Aeroportos_idAeroporto),
  --INDEX Escalas_FKAeroportoDestino(Aeroportos_idAeroporto),
  CONSTRAINT fk_escalas_aeroOrigem FOREIGN KEY(idAeroportoOrigem)
    REFERENCES Aeroportos(idAeroporto)
      
      ,
  CONSTRAINT fk_escalas_aeroDestino FOREIGN KEY(idAeroportoDestino)
    REFERENCES Aeroportos(idAeroporto)
      
      
);

 --Criação da Tabela Plano de Voo por etapas
 
 create table PlanoVoo (
id_plano_voo number,

constraint pk_plano_voo primary key (id_plano_voo));

alter table PlanoVoo add idModeloAeronave number not null;

alter table PlanoVoo add controlador_cpf CHAR(11)  NOT NULL;

alter table PlanoVoo add piloto_cpf CHAR(11) NOT NULL;

alter table PlanoVoo add idAeroportoOrigem NUMBER  NOT NULL;

alter table PlanoVoo add idAeroportoDestino NUMBER  NOT NULL;

alter table PlanoVoo add numeroSerie VARCHAR(20) NOT NULL;

alter table PlanoVoo add idTipoPlanoVoo NUMBER  NOT NULL;

alter table PlanoVoo add isAprovado CHAR(1) NOT NULL; 

alter table PlanoVoo add dataSaida DATE NOT NULL;

alter table PlanoVoo add dataChegada DATE NOT NULL;

alter table PlanoVoo add outrosDados VARCHAR(255) NULL;

alter table PlanoVoo add prioridade NUMBER  NOT NULL;

alter table PlanoVoo add altitudeCruzeiro NUMBER  NULL;

alter table PlanoVoo add diasOperacao NUMBER  NULL;

alter table PlanoVoo add validoDe DATE NULL;

alter table PlanoVoo add validoAte DATE  NULL;

ALTER TABLE PLANOVOO 
add   CONSTRAINT fk_planoVoo_piloto FOREIGN KEY(piloto_cpf)
    REFERENCES Piloto(cpf);

ALTER TABLE PLANOVOO 
add   CONSTRAINT  fk_planoVoo_Tipo FOREIGN KEY(idTipoPlanoVoo)
    REFERENCES TipoPlanoVoo(idTipoPlanoVoo);

ALTER TABLE PLANOVOO 
add   CONSTRAINT  fk_palnoVoo_controlador FOREIGN KEY(controlador_cpf)
    REFERENCES Controlador(cpf);

ALTER TABLE PLANOVOO 
add CONSTRAINT  fk_planoVoo_aeronave FOREIGN KEY(numeroSerie, idModeloAeronave)
    REFERENCES Aeronaves(numeroSerie, idModeloAeronave);

ALTER TABLE PLANOVOO 
add  CONSTRAINT fk_planoVoo_AeroOrigem FOREIGN KEY(idAeroportoOrigem)
    REFERENCES Aeroportos(idAeroporto);

ALTER TABLE PLANOVOO 
add CONSTRAINT fk_planoVoo_AeroDestino FOREIGN KEY(idAeroportoDestino)
    REFERENCES Aeroportos(idAeroporto);


CREATE TABLE Voo (
  idVoo NUMBER  NOT NULL ,
  id_plano_voo NUMBER  NOT NULL,
  numVoo VARCHAR(10) NOT NULL,
  dataSaida DATE NOT NULL,
  dataChegada DATE NOT NULL,
  velCruzeiroKm NUMBER  NULL,
  velCruzeiroMach NUMBER  NULL,
  velCruzeiroKnots NUMBER  NULL,
  CONSTRAINT pk_voo PRIMARY KEY(idVoo),
  --INDEX Voo_FKPlanoVoo(PlanoVoo_idPlanoVoo),
  CONSTRAINT fk_voo_plano FOREIGN KEY(id_plano_voo)
    REFERENCES PlanoVoo(id_plano_voo)
      
      
);

CREATE TABLE Voo_has_Controlador (
  idVoo NUMBER  NOT NULL,
  cpf CHAR(11)  NOT NULL,
  CONSTRAINT pk_voo_controlador PRIMARY KEY(idVoo, cpf),
  --INDEX Voo_has_Controlador_FKVoo(Voo_idVoo),
  --INDEX Voo_has_Controlador_FKControlador(Controlador_cpf),
  CONSTRAINT fk_voo_controlador_voo FOREIGN KEY(idVoo)
    REFERENCES Voo(idVoo),
  CONSTRAINT fk_voo_controlador_controlador FOREIGN KEY(cpf)
    REFERENCES Controlador(cpf)
      
      
);

CREATE TABLE PlanoVoo_has_Escalas (
  id_plano_voo NUMBER  NOT NULL,
  idEscalas NUMBER  NOT NULL,
  CONSTRAINT pk_plano_escalas PRIMARY KEY(id_plano_voo, idEscalas),
  --INDEX PlanoVoo_has_Escalas_FKPlanoVoo(PlanoVoo_idPlanoVoo),
  --INDEX PlanoVoo_has_Escalas_FKEscala(Escalas_idEscalas),
  CONSTRAINT fk_plano_escalas_plano FOREIGN KEY(id_plano_voo)
    REFERENCES PlanoVoo(id_plano_voo),
  CONSTRAINT fk_plano_escalas_escalas FOREIGN KEY(idEscalas)
    REFERENCES Escalas(idEscalas)
      
      
);


?
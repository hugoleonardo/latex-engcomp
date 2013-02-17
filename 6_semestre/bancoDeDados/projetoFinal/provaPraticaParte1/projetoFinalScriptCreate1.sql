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
  CONSTRAINT pk_pistas PRIMARY KEY(idPistas, idAeroporto));
  alter table Pistas 
add CONSTRAINT fk_pista_aeroporto FOREIGN KEY (idAeroporto)
    REFERENCES Aeroportos(idAeroporto);

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
 CONSTRAINT pk_piloto PRIMARY KEY(cpf));

 alter table Piloto
add CONSTRAINT fk_piloto_ciaAerea FOREIGN KEY(idCiaAerea)
    REFERENCES CiaAerea(idCiaAerea);
   

CREATE TABLE Aeronaves (
  numeroSerie VARCHAR(20) NOT NULL,
  idModeloAeronave NUMBER  NOT NULL,
  idCiaAerea NUMBER  NOT NULL,
  matricula VARCHAR(20) NOT NULL,
  CONSTRAINT pk_aeronaves PRIMARY KEY(numeroSerie, idModeloAeronave));

  alter table Aeronaves
add CONSTRAINT fk_aeronaves_ciaAerea FOREIGN KEY(idCiaAerea)
    REFERENCES CiaAerea(idCiaAerea);
 alter table Aeronaves
add CONSTRAINT fk_aeronaves_modelo FOREIGN KEY(idModeloAeronave)
    REFERENCES ModeloAeronave(idModeloAeronave);
      
      

CREATE TABLE Escalas (
  idEscalas NUMBER  NOT NULL ,
  idAeroportoOrigem NUMBER  NOT NULL,
  idAeroportoDestino NUMBER  NOT NULL,
  CONSTRAINT pk_escalas PRIMARY KEY(idEscalas));

  alter table Escalas 
add CONSTRAINT fk_escalas_aeroOrigem FOREIGN KEY(idAeroportoOrigem)
    REFERENCES Aeroportos(idAeroporto);
    
  alter table Escalas
add CONSTRAINT fk_escalas_aeroDestino FOREIGN KEY(idAeroportoDestino)
    REFERENCES Aeroportos(idAeroporto);
      
     
 
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
  CONSTRAINT pk_voo PRIMARY KEY(idVoo));

  alter table Voo
add CONSTRAINT fk_voo_plano FOREIGN KEY(id_plano_voo)
    REFERENCES PlanoVoo(id_plano_voo);
      
      

CREATE TABLE Voo_has_Controlador (
  idVoo NUMBER  NOT NULL,
  cpf CHAR(11)  NOT NULL,
  CONSTRAINT pk_voo_controlador PRIMARY KEY(idVoo, cpf));

  alter table Voo_has_Controlador  
add CONSTRAINT fk_voo_controlador_voo FOREIGN KEY(idVoo)
    REFERENCES Voo(idVoo);
  alter table Voo_has_Controlador 
add CONSTRAINT fk_voo_controlador_controlador FOREIGN KEY(cpf)
    REFERENCES Controlador(cpf);
      
      


CREATE TABLE PlanoVoo_has_Escalas (
  id_plano_voo NUMBER  NOT NULL,
  idEscalas NUMBER  NOT NULL,
  CONSTRAINT pk_plano_escalas PRIMARY KEY(id_plano_voo, idEscalas));

alter table PlanoVoo_has_Escalas 
add  CONSTRAINT fk_plano_escalas_plano FOREIGN KEY(id_plano_voo)
    REFERENCES PlanoVoo(id_plano_voo);
alter table PlanoVoo_has_Escalas 
add  CONSTRAINT fk_plano_escalas_escalas FOREIGN KEY(idEscalas)
    REFERENCES Escalas(idEscalas);
      


insert into controlador (cpf,matricula,endereco,nome,telefone,email,anoAdmissao) values ('11111111111', 01, 'humaita', 'Hugo', '22222221', 'hugo@gmail.com', 1990);
insert into controlador (cpf,matricula,endereco,nome,telefone,email,anoAdmissao) values ('11111111112', 02, ' timbo', 'Welton', '22222222', 'welton@gmail.com', 1991);
insert into controlador (cpf,matricula,endereco,nome,telefone,email,anoAdmissao) values ('11111111113', 03, ' vileta', 'Danilo', '22222223', 'danilo@gmail.com', 1992);
insert into controlador (cpf,matricula,endereco,nome,telefone,email,anoAdmissao) values ('11111111114', 04, ' chaco', 'Joao', '22222224', 'joao@gmail.com', 1993);
insert into controlador (cpf,matricula,endereco,nome,telefone,email,anoAdmissao) values ('11111111115', 05, ' mariz barros', 'Maria', '22222225', 'maria@gmail.com', 1994);



insert into TipoPlanoVoo (idTipoPlanoVoo, nome) values (9000, 'repetitivo');
insert into TipoPlanoVoo (idTipoPlanoVoo, nome) values (8000, 'simples');
insert into TipoPlanoVoo (idTipoPlanoVoo, nome) values (7000, 'completo');
insert into TipoPlanoVoo (idTipoPlanoVoo, nome) values (6000, 'explorador');
insert into TipoPlanoVoo (idTipoPlanoVoo, nome) values (5000, 'viajante');

insert into ModeloAeronave (idModeloAeronave, modelo, peso, numPassageiros, pesoMax, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values
(1,'boeing 785',1000,123,1800,300,400,250);
insert into ModeloAeronave (idModeloAeronave, modelo, peso, numPassageiros, pesoMax, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values
(2,'boeing 786',1010,123,1800,300,400,250);
insert into ModeloAeronave (idModeloAeronave, modelo, peso, numPassageiros, pesoMax, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values
(3,'boeing 787',1020,123,1800,300,400,250);
insert into ModeloAeronave (idModeloAeronave, modelo, peso, numPassageiros, pesoMax, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values
(4,'boeing 786',1010,123,1800,300,400,250);
insert into ModeloAeronave (idModeloAeronave, modelo, peso, numPassageiros, pesoMax, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values
(5,'boeing 785',1000,123,1800,300,400,250);

insert into Aeroportos (idAeroporto, codigoICAO, localidade, numPistas, numPlatEmbarque, capacPassAno) values (200, '1234' ,'Parana', 10, 8, 1990);
insert into Aeroportos (idAeroporto, codigoICAO, localidade, numPistas, numPlatEmbarque, capacPassAno) values (300, '1235' ,'Sao Paulo', 12, 10, 1994);
insert into Aeroportos (idAeroporto, codigoICAO, localidade, numPistas, numPlatEmbarque, capacPassAno) values (400, '1236' ,'Rio de Janeiro', 11, 10, 1993);
insert into Aeroportos (idAeroporto, codigoICAO, localidade, numPistas, numPlatEmbarque, capacPassAno) values (500, '1237' ,'Belem', 5, 3, 1999);
insert into Aeroportos (idAeroporto, codigoICAO, localidade, numPistas, numPlatEmbarque, capacPassAno) values (600, '1239' ,'Manaus', 12, 15, 1989);


insert into CiaAerea (idCiaAerea,codigoANAC,nome) values (001,'JJ', 'Tam linhas Aereas');
insert into CiaAerea (idCiaAerea,codigoANAC,nome) values (002,'GOL', 'Gol Linhas Aereas');
insert into CiaAerea (idCiaAerea,codigoANAC,nome) values (003,'AV', 'Avianca');
insert into CiaAerea (idCiaAerea,codigoANAC,nome) values (004,'TR', 'Trip Linhas Aereas');
insert into CiaAerea (idCiaAerea,codigoANAC,nome) values (005,'AC', 'Air Canada');


insert into pistas (idPistas, idAeroporto, extensao) values (1,200,1400);
insert into pistas (idPistas, idAeroporto, extensao) values (2,300,1500);
insert into pistas (idPistas, idAeroporto, extensao) values (3,400,1600);
insert into pistas (idPistas, idAeroporto, extensao) values (4,500,1700);
insert into pistas (idPistas, idAeroporto, extensao) values (5,600,1800);


insert into piloto (cpf, matricula, idCiaAerea, codigoANAC, nome, telefone, email, horasVoo, milhasVoadas) values ('99999999999', 01, 001, '7777777778', 'Hugo San', '55555555', 'hugosantos@gmail.com', 100, 10000);   
insert into piloto (cpf, matricula, idCiaAerea, codigoANAC, nome, telefone, email, horasVoo, milhasVoadas) values ('99999999998', 01, 002, '7777777779', 'Danilo Pereira', '55555556', 'danilop@gmail.com', 200, 20000);
insert into piloto (cpf, matricula, idCiaAerea, codigoANAC, nome, telefone, email, horasVoo, milhasVoadas) values ('99999999997', 01, 003, '7777777771', 'Welton Xavier', '55555557', 'WeltonX@gmail.com', 300, 30000);
insert into piloto (cpf, matricula, idCiaAerea, codigoANAC, nome, telefone, email, horasVoo, milhasVoadas) values ('99999999996', 01, 004, '7777777772', 'Tales Leandro', '55555558', 'LeandroT@gmail.com', 400, 40000);
insert into piloto (cpf, matricula, idCiaAerea, codigoANAC, nome, telefone, email, horasVoo, milhasVoadas) values ('99999999995', 01, 005, '7777777773', 'Severino Cabral', '55555559', 'Severino@gmail.com', 500, 50000);


insert into Aeronaves (numeroSerie,idModeloAeronave,idCiaAerea,matricula) values ('00001', 1, 001,'123456789');
insert into Aeronaves (numeroSerie,idModeloAeronave,idCiaAerea,matricula) values ('00002', 2, 002,'789456');
insert into Aeronaves (numeroSerie,idModeloAeronave,idCiaAerea,matricula) values ('00003', 3, 003,'4585259');
insert into Aeronaves (numeroSerie,idModeloAeronave,idCiaAerea,matricula) values ('00004', 4, 004,'789456123');
insert into Aeronaves (numeroSerie,idModeloAeronave,idCiaAerea,matricula) values ('00005', 5, 005,'741963258');
 

insert into escalas (idEscalas, idAeroportoOrigem, idAeroportoDestino) values (1,200,300);
insert into escalas (idEscalas, idAeroportoOrigem, idAeroportoDestino) values (2,300,400);
insert into escalas (idEscalas, idAeroportoOrigem, idAeroportoDestino) values (3,400,500);
insert into escalas (idEscalas, idAeroportoOrigem, idAeroportoDestino) values (4,500,600);
insert into escalas (idEscalas, idAeroportoOrigem, idAeroportoDestino) values (5,600,200);
      
   

insert into PlanoVoo (id_plano_voo,idModeloAeronave,controlador_cpf,piloto_cpf,idAeroportoOrigem,idAeroportoDestino,numeroSerie,idTipoPlanoVoo,isAprovado,dataSaida,
dataChegada,outrosDados,prioridade,altitudeCruzeiro,diasOperacao,validoDe,validoAte) values (1,1,'11111111111','99999999999',200,300,'00001',7000,'Y','18/02/2013','18/02/2013',
null, 1, 36000, 1,null,null);

insert into PlanoVoo (id_plano_voo,idModeloAeronave,controlador_cpf,piloto_cpf,idAeroportoOrigem,idAeroportoDestino,numeroSerie,idTipoPlanoVoo,isAprovado,dataSaida,
dataChegada,outrosDados,prioridade,altitudeCruzeiro,diasOperacao,validoDe,validoAte) values (2,2,'11111111112','99999999998',500,400,'00002',8000,'Y','21/02/2013','22/02/2013',
null, 1, 35000, 1,null,null);

insert into PlanoVoo (id_plano_voo,idModeloAeronave,controlador_cpf,piloto_cpf,idAeroportoOrigem,idAeroportoDestino,numeroSerie,idTipoPlanoVoo,isAprovado,dataSaida,
dataChegada,outrosDados,prioridade,altitudeCruzeiro,diasOperacao,validoDe,validoAte) values (3,3,'11111111113','99999999997',200,600,'00003',8000,'N','15/02/2013','16/02/2013',
null, 0, 39000, 1,null,null);

insert into PlanoVoo (id_plano_voo,idModeloAeronave,controlador_cpf,piloto_cpf,idAeroportoOrigem,idAeroportoDestino,numeroSerie,idTipoPlanoVoo,isAprovado,dataSaida,
dataChegada,outrosDados,prioridade,altitudeCruzeiro,diasOperacao,validoDe,validoAte) values (4,4,'11111111114','99999999996',600,200,'00004',7000,'N','17/02/2013','18/02/2013',
null, 2, 37000, 1,null,null);

insert into PlanoVoo (id_plano_voo,idModeloAeronave,controlador_cpf,piloto_cpf,idAeroportoOrigem,idAeroportoDestino,numeroSerie,idTipoPlanoVoo,isAprovado,dataSaida,
dataChegada,outrosDados,prioridade,altitudeCruzeiro,diasOperacao,validoDe,validoAte) values (5,5,'11111111115','99999999995',200,500,'00005',9000,'Y','22/02/2013','23/02/2013',
null, 3, 36000, 4,'14/02/2013','17/02/2013');


      
insert into voo (idVoo,id_plano_voo, numVoo, dataSaida, dataChegada, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values (1,1,'TAM1231','01/01/2013','01/02/2013',301,401,251);
insert into voo (idVoo,id_plano_voo, numVoo, dataSaida, dataChegada, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values (2,2,'TAM1232','01/03/2013','01/04/2013',302,402,252);
insert into voo (idVoo,id_plano_voo, numVoo, dataSaida, dataChegada, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values (3,3,'TAM1233','01/05/2013','01/06/2013',303,403,253);
insert into voo (idVoo,id_plano_voo, numVoo, dataSaida, dataChegada, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values (4,4,'TAM1234','01/07/2013','01/08/2013',304,404,254);
insert into voo (idVoo,id_plano_voo, numVoo, dataSaida, dataChegada, velCruzeiroKm, velCruzeiroMach, velCruzeiroKnots) values (5,5,'TAM1235','01/09/2013','01/10/2013',305,405,255);


insert into Voo_has_controlador (idVoo, cpf) values (1, '11111111111');      
insert into Voo_has_controlador (idVoo, cpf) values (2, '11111111112');
insert into Voo_has_controlador (idVoo, cpf) values (3, '11111111113');
insert into Voo_has_controlador (idVoo, cpf) values (4, '11111111114');
insert into Voo_has_controlador (idVoo, cpf) values (5, '11111111115');


insert into planoVoo_has_Escalas (id_plano_voo, idEscalas) values (1,2);
insert into planoVoo_has_Escalas (id_plano_voo, idEscalas) values (2,3);
insert into planoVoo_has_Escalas (id_plano_voo, idEscalas) values (3,4);
insert into planoVoo_has_Escalas (id_plano_voo, idEscalas) values (4,5);
insert into planoVoo_has_Escalas (id_plano_voo, idEscalas) values (5,1);



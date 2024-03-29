CREATE TABLE CONVENIO( 
    CNPJ VARCHAR(16) PRIMARY KEY, 
    NOME VARCHAR(45), 
    DESCONTO VARCHAR(15) 
);

CREATE TABLE PACIENTE( 
    CPF VARCHAR(11) PRIMARY KEY, 
    NOME VARCHAR(50),
    NASCIMENTO DATE,
    IDADE NUMBER, 
    END_RUA VARCHAR (15),  
    END_CIDADE VARCHAR(25), 
    END_NUM VARCHAR(10),  
    END_BAIRRO VARCHAR(25), 
    CONTATO1 VARCHAR(60), 
    CONTATO2 VARCHAR(60), 
    CONVENIO VARCHAR(16), 
    CONSTRAINT FK_PACIENTE_CONV FOREIGN KEY (CONVENIO) REFERENCES CONVENIO (CNPJ) ON DELETE CASCADE 
);

CREATE TABLE DENTISTA( 
    CPF VARCHAR(11) PRIMARY KEY,
    NOME VARCHAR(50),
    NASCIMENTO DATE, 
    IDADE NUMBER, 
    ESPECIALIZACAO1 VARCHAR(40), 
	ESPECIALIZACAO2 VARCHAR(40), 
	END_RUA VARCHAR (15),  
    END_CIDADE VARCHAR(25), 
    END_NUM VARCHAR(10),  
    END_BAIRRO VARCHAR(25), 
    CONTATO1 VARCHAR(60), 
    CONTATO2 VARCHAR(60) 
);

CREATE TABLE FUNCIONARIO( 
    CPF VARCHAR(11) PRIMARY KEY,
    NOME VARCHAR(50),
    NASCIMENTO DATE, 
    IDADE NUMBER, 
    END_RUA VARCHAR (15),  
    END_CIDADE VARCHAR(25), 
    END_NUM VARCHAR(10),  
    END_BAIRRO VARCHAR(25), 
    CONTATO1 VARCHAR(60), 
    CONTATO2 VARCHAR(60) 
);

CREATE TABLE CHEFIA( 
    CHEFE VARCHAR(11), 
    SUBORDINADO VARCHAR(11), 
    CONSTRAINT PK_CHEFIA PRIMARY KEY (CHEFE, SUBORDINADO), 
    CONSTRAINT FK_CHEFE_SUB FOREIGN KEY (CHEFE) REFERENCES FUNCIONARIO (CPF) ON DELETE CASCADE, 
    CONSTRAINT FK_SUB_CHEFE FOREIGN KEY (SUBORDINADO) REFERENCES FUNCIONARIO (CPF) ON DELETE CASCADE 
);

CREATE TABLE PIS( 
    NUM VARCHAR(11) PRIMARY KEY, 
    CPF VARCHAR(11) UNIQUE NOT NULL, 
    CONSTRAINT FK_PIS_FUNCIO FOREIGN KEY (CPF) REFERENCES FUNCIONARIO (CPF) ON DELETE CASCADE 
);

CREATE TABLE BENEFICIOS( 
    BENEFICIOS VARCHAR(100), 
    NUM VARCHAR(11), 
    CONSTRAINT PK_BENEFICIOS PRIMARY KEY (BENEFICIOS, NUM), 
    CONSTRAINT FK_BENEF_PIS FOREIGN KEY (NUM) REFERENCES PIS(NUM) ON DELETE CASCADE 
);

CREATE TABLE CONSULTORIO( 
    CEP VARCHAR (12),  
    ENDERECO VARCHAR (50),  
    CIDADE VARCHAR (25), 
    NOME VARCHAR (45), 
    CONSTRAINT PK_CONSULTORIO PRIMARY KEY (CEP, ENDERECO) 
);

CREATE TABLE SERVICO ( 
    CEP VARCHAR (12),  
    ENDERECO VARCHAR (50),  
    CPF VARCHAR (11), 
    DT_ADMISSAO DATE, 
    EXPEDIENTE VARCHAR(100), 
    FUNCAO VARCHAR(50), 
    CONSTRAINT PK_SERVICO PRIMARY KEY (CEP, ENDERECO, CPF), 
    CONSTRAINT FK_SERVICO_FUNCIO FOREIGN KEY (CPF) REFERENCES FUNCIONARIO (CPF) ON DELETE CASCADE, 
 	CONSTRAINT FK_SERVICO_CONSULTORIO FOREIGN KEY (CEP, ENDERECO) REFERENCES CONSULTORIO (CEP, ENDERECO) ON DELETE CASCADE 
);

CREATE TABLE SALA( 
	CEP VARCHAR (12), 
    ENDERECO VARCHAR(50), 
    NUM VARCHAR(5), 
    CONSTRAINT PK_SALA PRIMARY KEY (CEP, ENDERECO, NUM), 
 	CONSTRAINT FK_SALA_CONSULTORIO FOREIGN KEY (CEP, ENDERECO) REFERENCES CONSULTORIO (CEP, ENDERECO) ON DELETE CASCADE 
);

CREATE TABLE CRO( 
    REGISTRO VARCHAR(14) PRIMARY KEY, 
    UF VARCHAR (2), 
    CPF_DENTISTA VARCHAR(11) NOT NULL, 
    CONSTRAINT FK_CRO_DENTISTA FOREIGN KEY (CPF_DENTISTA) REFERENCES DENTISTA (CPF) ON DELETE CASCADE 
);

CREATE TABLE CONSULTA( 
    CEP VARCHAR (12), 
    ENDERECO VARCHAR(50), 
    NUM_SALA VARCHAR(5), 
    CPF_PACIENTE VARCHAR (11), 
    CPF_DENTISTA VARCHAR (11),  
    MOMENTO_CONSULTA TIMESTAMP, 
    VALOR FLOAT, 
    TIPO VARCHAR(30), 
    CONSTRAINT PK_CONSULTA PRIMARY KEY(CEP, ENDERECO, NUM_SALA,CPF_DENTISTA,CPF_PACIENTE,MOMENTO_CONSULTA), 
    CONSTRAINT FK_CONSULTA_SALA FOREIGN KEY (CEP, ENDERECO, NUM_SALA) REFERENCES SALA(CEP, ENDERECO, NUM) ON DELETE CASCADE, 
    CONSTRAINT FK_CONSULTA_DENTISTA FOREIGN KEY (CPF_DENTISTA) REFERENCES DENTISTA(CPF) ON DELETE CASCADE, 
    CONSTRAINT FK_CONSULTA_PACIENTE FOREIGN KEY (CPF_PACIENTE) REFERENCES PACIENTE(CPF) ON DELETE CASCADE 
);

CREATE TABLE DOCUMENTO ( 
    REGISTRO VARCHAR (14),  
    INSTANTE_EMISSAO TIMESTAMP, 
    MOMENTO_CONSULTA TIMESTAMP, 
    INSTRUCOES VARCHAR(256),  
    CEP VARCHAR (12) NOT NULL, 
    ENDERECO VARCHAR(50) NOT NULL, 
    NUM_SALA VARCHAR(5) NOT NULL, 
    CPF_PACIENTE VARCHAR (11) NOT NULL, 
    CPF_DENTISTA VARCHAR (11) NOT NULL,  
    CONSTRAINT FK_DOC_CONSULTA FOREIGN KEY (CEP, ENDERECO, NUM_SALA, CPF_DENTISTA, CPF_PACIENTE, MOMENTO_CONSULTA) REFERENCES CONSULTA(CEP, ENDERECO, NUM_SALA, CPF_DENTISTA, CPF_PACIENTE, MOMENTO_CONSULTA) ON DELETE CASCADE, 
    CONSTRAINT FK_DOC_REGISTRO FOREIGN KEY (REGISTRO) REFERENCES CRO(REGISTRO) ON DELETE CASCADE, 
    CONSTRAINT PK_DOCUMENTO PRIMARY KEY (REGISTRO, INSTANTE_EMISSAO) 
);

CREATE TABLE MEDICAMENTO( 
    NMR VARCHAR(13) PRIMARY KEY, 
    DOSAGEM VARCHAR(50), 
    TIPO VARCHAR(25), 
    NOME VARCHAR(50) 
);

CREATE TABLE ATENDIMENTO_DENTISTA( 
    CEP VARCHAR (12), 
    ENDERECO VARCHAR(50), 
    CPF VARCHAR(11), 
    EXPEDIENTE VARCHAR(14), 
    CONSTRAINT PK_ATENDIMENTO PRIMARY KEY(CEP, ENDERECO,CPF), 
    CONSTRAINT FK_ATENDE_CONSULTORIO FOREIGN KEY (CEP, ENDERECO) REFERENCES CONSULTORIO (CEP, ENDERECO) ON DELETE CASCADE 
);

CREATE TABLE ACEITA_CONVENIO( 
    CPF_DENTISTA VARCHAR (11), 
    CNPJ VARCHAR (16), 
    CONSTRAINT PK_ACEITA PRIMARY KEY(CPF_DENTISTA, CNPJ), 
    CONSTRAINT FK_ACEITA_DENTISTA FOREIGN KEY (CPF_DENTISTA) REFERENCES DENTISTA(CPF) ON DELETE CASCADE, 
    CONSTRAINT FK_ACEITA_CONVENIO FOREIGN KEY (CNPJ) REFERENCES CONVENIO(CNPJ) ON DELETE CASCADE 
);

CREATE TABLE CONTROLE_PRESCRICAO( 
    REGISTRO VARCHAR(14), 
    INSTANTE_EMISSAO TIMESTAMP, 
    REMEDIO VARCHAR(13), 
    CONSTRAINT PK_PRESCRICAO PRIMARY KEY(REGISTRO, INSTANTE_EMISSAO, REMEDIO), 
	CONSTRAINT FK_PRESCRICAO_DOC FOREIGN KEY (REGISTRO, INSTANTE_EMISSAO) REFERENCES DOCUMENTO(REGISTRO, INSTANTE_EMISSAO) ON DELETE CASCADE, 
	CONSTRAINT FK_PRESCRICAO_MEDICAMENTO FOREIGN KEY (REMEDIO) REFERENCES MEDICAMENTO(NMR) ON DELETE CASCADE 
);
-- Populando a tabela CONVENIO
INSERT INTO CONVENIO VALUES ('12345678901234', 'Convenio Hapvida', '10%');
INSERT INTO CONVENIO VALUES ('98765432109876', 'Convenio Unimed', '15%');
INSERT INTO CONVENIO VALUES ('45678901234567', 'Convenio Saúde e amor', '20%');

-- Populando a tabela PACIENTE
INSERT INTO PACIENTE VALUES ('11122233333', 'Roberto',  TO_DATE('15/05/1990', 'DD/MM/YYYY'), 34, 'Rua Mangabeira', 'Recife', '123', 'Macaxeira', '984155152', 'allysonryan.ares@gmail.com', '45678901234567');
INSERT INTO PACIENTE VALUES ('22233344428', 'Paula', TO_DATE('20/10/1985', 'DD/MM/YYYY'), 39, 'Rua Guanabara', 'Jaboatão', '456', 'Areias', '984155662', 'paula.lucena@outlook.com', NULL);
INSERT INTO PACIENTE VALUES ('33344455577', 'Gustavo', TO_DATE('10/03/2000', 'DD/MM/YYYY'), 24, 'Rua Jenipapo', 'Paulista', '789', 'Largo', '994252152', '987664312', '98765432109876');

-- Populando a tabela PACIENTE com dados incompletos
INSERT INTO PACIENTE VALUES ('44455566600', 'Luis', TO_DATE('25/07/1982', 'DD/MM/YYYY'), 42, NULL, NULL, NULL, NULL, NULL, NULL, '12345678901234');
INSERT INTO PACIENTE VALUES ('55566677794', 'Miguel', TO_DATE('12/12/1975', 'DD/MM/YYYY'), 49, 'Rua Jiló', 'Recife', '10', 'Werneck', '994327621', 'miguelg@yahoo.com.br', '98765432109876');
INSERT INTO PACIENTE VALUES ('66677788843', 'Júlia', NULL, 33, 'Rua Aipim', 'Paulista', '30', 'Areias', '987775432', '@julia_lim4', '45678901234567');

-- Populando a tabela DENTISTA
INSERT INTO DENTISTA VALUES ('44455566677', 'Alberto', TO_DATE('25/07/1982', 'DD/MM/YYYY'), 42, 'Ortodontia', 'Implantodontia', 'Rua Jiló', 'Recife', '10', 'Werneck', '994322345', '30012444');
INSERT INTO DENTISTA VALUES ('55566677788', 'Rosangela', TO_DATE('12/12/1975', 'DD/MM/YYYY'), 49, 'Endodontia', NULL, 'Rua Caqui', 'Jaboatão', '20', 'Macaxeira', '994300120', '988435762');
INSERT INTO DENTISTA VALUES ('66677788899', 'Ivan', TO_DATE('30/04/1988', 'DD/MM/YYYY'), 36, 'Periodontia', 'Ortodontia', 'Rua Aipim', 'Paulista', '30', 'Areias', '99662482', NULL);
INSERT INTO DENTISTA VALUES ('77788899900', 'Ricardo',TO_DATE('01/01/1970', 'DD/MM/YYYY'), 54, 'Ortodontia', 'Implantodontia', NULL, NULL, NULL, NULL, 'ricardoutor@gmail.com', '@dr.ricardo');

-- Populando a tabela FUNCIONARIO
INSERT INTO FUNCIONARIO VALUES ('14755341400', 'Celso', TO_DATE('01/01/1970', 'DD/MM/YYYY'), 54, 'Rua Pitaya', 'Igarassu', '100', 'Forte Orange', NULL, '98664323');
INSERT INTO FUNCIONARIO VALUES ('88899900011', 'Júlio', NULL, 41, 'Rua Tangerina', 'Paudalho', NULL, 'Primavera', '981242156', '987654432');
INSERT INTO FUNCIONARIO VALUES ('99900011122', 'Angela', TO_DATE('05/09/1995', 'DD/MM/YYYY'), 29, 'Rua Caqui', 'Camaragibe', '300', 'Centro', '982747632', '987654222');

-- Populando a tabela CHEFIA
INSERT INTO CHEFIA VALUES ('14755341400', '88899900011');
INSERT INTO CHEFIA VALUES ('88899900011', '99900011122');

-- Populando a tabela CHEFIA com funcionários que são chefes de mais de um outro funcionário
INSERT INTO CHEFIA VALUES ('14755341400', '99900011122');

-- Populando a tabela PIS
INSERT INTO PIS VALUES ('12345678901', '14755341400');
INSERT INTO PIS VALUES ('23456789012', '88899900011');
INSERT INTO PIS VALUES ('34567890123', '99900011122');

-- Populando a tabela BENEFICIOS
INSERT INTO BENEFICIOS VALUES ('Plano de Saúde', '12345678901');
INSERT INTO BENEFICIOS VALUES ('Vale Alimentação', '23456789012');
INSERT INTO BENEFICIOS VALUES ('Vale Transporte', '34567890123');

-- Populando a tabela CONSULTORIO
INSERT INTO CONSULTORIO VALUES ('12345678', 'Rua cortez, 100', 'Olinda', 'Sorridents');
INSERT INTO CONSULTORIO VALUES ('23456789', 'Avenida norte, 200', 'Recife', 'Dentin');
INSERT INTO CONSULTORIO VALUES ('34567890', 'Praça dos campos, 300', 'Caruaru', 'Bom Dente');

-- Populando a tabela SERVICO
INSERT INTO SERVICO VALUES ('12345678', 'Rua cortez, 100', '14755341400', TO_DATE('01/01/2020', 'DD/MM/YYYY'), NULL, 'Recepcionista');
INSERT INTO SERVICO VALUES ('23456789', 'Avenida norte, 200', '88899900011', NULL,'Segunda a Sábado, 09:00 - 19:00', 'Atendente');
INSERT INTO SERVICO VALUES ('34567890', 'Praça dos campos, 300', '99900011122', TO_DATE('15/03/2021', 'DD/MM/YYYY'), 'Segunda e Quinta, 10:00 - 20:00', 'Auxiliar Administrativo');


-- Populando a tabela SALA
INSERT INTO SALA VALUES ('12345678', 'Rua cortez, 100', '1');
INSERT INTO SALA VALUES ('23456789', 'Avenida norte, 200', '2');
INSERT INTO SALA VALUES ('34567890', 'Praça dos campos, 300', '3');

-- Populando a tabela SALA com salas no mesmo consultório
INSERT INTO SALA VALUES ('12345678', 'Rua cortez, 100', '2');
INSERT INTO SALA VALUES ('12345678', 'Rua cortez, 100', '3');

-- Populando a tabela CRO
INSERT INTO CRO VALUES ('RS123456', 'RS', '44455566677');
INSERT INTO CRO VALUES ('SP654321', 'SP', '55566677788');
INSERT INTO CRO VALUES ('MG987654', 'MG', '66677788899');

-- Populando a tabela CONSULTAS
INSERT INTO CONSULTA VALUES ('12345678', 'Rua cortez, 100', '1', '11122233333', '44455566677', TO_TIMESTAMP('15/01/2023 10:30:00', 'DD/MM/YYYY HH24:MI:SS'), 100.00, 'Rotina');
INSERT INTO CONSULTA VALUES ('23456789', 'Avenida norte, 200', '2', '22233344428', '55566677788', TO_TIMESTAMP('20/02/2023 08:30:00', 'DD/MM/YYYY HH24:MI:SS'), 150.00, 'Emergência');
INSERT INTO CONSULTA VALUES ('34567890', 'Praça dos campos, 300', '3', '33344455577', '66677788899', TO_TIMESTAMP('25/03/2023 10:20:00', 'DD/MM/YYYY HH24:MI:SS'), 120.00, NULL);
INSERT INTO CONSULTA VALUES ('34567890', 'Praça dos campos, 300', '3', '44455566600', '66677788899', TO_TIMESTAMP('25/03/2023 10:50:00', 'DD/MM/YYYY HH24:MI:SS'), NULL, 'Check-up');

-- Populando a tabela DOCUMENTOS
INSERT INTO DOCUMENTO VALUES ('RS123456', TO_TIMESTAMP('15/01/2023 10:30:00', 'DD/MM/YYYY HH24:MI:SS'),TO_TIMESTAMP('15/01/2023 10:30:00', 'DD/MM/YYYY HH24:MI:SS'), 'Extração dentária', '12345678', 'Rua cortez, 100', '1', '11122233333', '44455566677');
INSERT INTO DOCUMENTO VALUES ('SP654321', TO_TIMESTAMP('20/02/2023 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_TIMESTAMP('20/02/2023 08:30:00', 'DD/MM/YYYY HH24:MI:SS'),'Cárie em metade dos dentes', '23456789', 'Avenida norte, 200', '2', '22233344428', '55566677788');
INSERT INTO DOCUMENTO VALUES ('RS123456', TO_TIMESTAMP('15/01/2023 10:40:00', 'DD/MM/YYYY HH24:MI:SS'), TO_TIMESTAMP('15/01/2023 10:30:00', 'DD/MM/YYYY HH24:MI:SS'),'Apenas um dente na boca, preocupante', '12345678', 'Rua cortez, 100', '1', '11122233333', '44455566677');

-- Populando a tabela MEDICAMENTOS
INSERT INTO MEDICAMENTO VALUES ('1234567890123', '10mg', 'Comprimido', 'Diclac');
INSERT INTO MEDICAMENTO VALUES ('2345678901234', '5mL', 'Solução', 'Probenxil ');
INSERT INTO MEDICAMENTO VALUES ('3456789012345', '200mg', 'Cápsula', 'Neotaren ');

-- Populando a tabela ATENDIMENTOS
INSERT INTO ATENDIMENTO_DENTISTA VALUES ('12345678', 'Rua cortez, 100', '44455566677', '08:00 - 18:00');
INSERT INTO ATENDIMENTO_DENTISTA VALUES ('23456789', 'Avenida norte, 200', '55566677788', '09:00 - 19:00');
INSERT INTO ATENDIMENTO_DENTISTA VALUES ('34567890', 'Praça dos campos, 300', '66677788899', '10:00 - 20:00');

-- Populando a tabela DENTISTAS ACEITAM CONVÊNIOS
INSERT INTO ACEITA_CONVENIO VALUES ('44455566677', '12345678901234');
INSERT INTO ACEITA_CONVENIO VALUES ('55566677788', '98765432109876');
INSERT INTO ACEITA_CONVENIO VALUES ('66677788899', '45678901234567');
INSERT INTO ACEITA_CONVENIO VALUES ('44455566677', '45678901234567');


-- Populando a tabela DOCUMENTO PRESCREVE MEDICAMENTO
INSERT INTO CONTROLE_PRESCRICAO VALUES ('RS123456', TO_TIMESTAMP('15/01/2023 10:30:00', 'DD/MM/YYYY HH24:MI:SS'), '1234567890123');
INSERT INTO CONTROLE_PRESCRICAO VALUES ('SP654321', TO_TIMESTAMP('20/02/2023 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), '2345678901234');
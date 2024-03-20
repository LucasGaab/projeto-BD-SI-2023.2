--**Nome dos dentistas que prescreveram mais de um medicamento (Group By e Having)
SELECT D.NOME
FROM DENTISTA D
WHERE D.CPF IN (SELECT C.CPF_DENTISTA
FROM CRO C
WHERE C.CPF_DENTISTA = D.CPF 
AND C.REGISTRO IN (SELECT P.REGISTRO
FROM CONTROLE_PRESCRICAO P
GROUP BY P.REGISTRO
HAVING COUNT(*) > 1
));

--**Todos os consultórios onde não há funcionários.(Antijoin)
SELECT C.ENDERECO
FROM CONSULTORIO C
WHERE NOT EXISTS (SELECT *
FROM SERVICO);

--**CPF e nome de funcionários e dentistas por consultório (Inner Join)
SELECT D.NOME AS DENTISTA, F.NOME AS FUNCIONÁRIO, CONCAT(CONCAT(C.ENDERECO, ', '), C.NOME) AS CONSULTÓRIO 
FROM CONSULTORIO C INNER JOIN ATENDIMENTO_DENTISTA A ON (C.CEP = A.CEP) INNER JOIN DENTISTA D ON (D.CPF = A.CPF), FUNCIONARIO F, SERVICO S
WHERE (S.CEP = A.CEP) AND (S.CPF = F.CPF);

--**Cidades que possuem de uma a três pessoas registradas(Operação com conjuntos)
SELECT END_CIDADE AS CIDADE, COUNT(*) AS NUMERO_DE_PESSOAS
FROM (
SELECT P.END_CIDADE,P.CPF 
FROM PACIENTE p
UNION ALL
SELECT D.END_CIDADE, D.CPF
FROM DENTISTA D
UNION ALL
SELECT F.END_CIDADE, F.CPF
FROM FUNCIONARIO F
) 
WHERE END_CIDADE IS NOT NULL
GROUP BY END_CIDADE
HAVING COUNT(*) BETWEEN 1 AND 3;

--**Cidades onde há ao menos dois pacientes com mais de 20 anos e em que a média de idade naquela cidade seja superior a 20 (Subselect com tabela)
SELECT P.END_CIDADE--, COUNT(*) AS NUMERO_DE_PACIENTES, AVG(IDADE) AS MEDIA_IDADE
FROM (SELECT P.END_CIDADE, P.IDADE
FROM PACIENTE P
WHERE P.IDADE > 20 AND P.END_CIDADE IS NOT NULL) P
GROUP BY END_CIDADE
HAVING COUNT(*) >= 2 AND AVG(P.IDADE) > 20;

--**Todos os consultório onde dentistas realizaram pelo menos um atendimento, pelo menos um funcionário trabalha e pelo menos um paciente tem convênio aceito por um dentista que trabalha lá.
--(Semijoin)
SELECT CONCAT(CONCAT(C.ENDERECO, ', '), C.NOME) AS CONSULTÓRIO 
FROM CONSULTORIO C
WHERE EXISTS (SELECT *
FROM CONSULTA CO
WHERE CO.CEP = C.CEP)
AND EXISTS (SELECT *
FROM SERVICO S
WHERE S.CEP = C.CEP)
AND EXISTS (SELECT *
FROM PACIENTE P
WHERE P.CONVENIO IN(SELECT AC.CNPJ
FROM ACEITA_CONVENIO AC
WHERE AC.CPF_DENTISTA IN(SELECT A.CPF
FROM ATENDIMENTO_DENTISTA A
WHERE A.CEP = C.CEP)));

--**Consultas com o preço acima da média e nome dos pacientes consultados (Escalar)
SELECT CO.MOMENTO_CONSULTA, CO.ENDERECO, CO.VALOR, P.NOME
FROM CONSULTA CO, PACIENTE P
WHERE (CO.CPF_PACIENTE = P.CPF)
AND CO.VALOR > (SELECT TRUNC(AVG(VALOR), 2) FROM CONSULTA);

--**Projetar todos os pacientes e suas respectivas consultas, preços e descontos pelo convênio, inclusive aqueles que não se consultaram ou não tem convênio ou que não tiveram consulta paga(Junção externa)
SELECT COALESCE(TO_CHAR(C.MOMENTO_CONSULTA), 'Nenhuma consulta registrada') AS CONSULTA, 
COALESCE(TO_CHAR(C.VALOR), 'Valor não estimado/consulta não obtida') AS VALOR, 
P.NOME AS NOME_PACIENTE, COALESCE(CV.DESCONTO, 'Sem desconto') AS DESCONTO_CONVÊNIO
FROM CONSULTA C FULL OUTER JOIN PACIENTE P ON (C.CPF_PACIENTE = P.CPF) FULL OUTER JOIN CONVENIO CV ON P.CONVENIO = CV.CNPJ;

--**Dentistas que têm a mesma especialização e moram na mesma cidade que o dentista com CPF '44455566677'(Linha)
SELECT D.NOME
FROM DENTISTA D
WHERE (D.ESPECIALIZACAO1, D.END_CIDADE) = (SELECT D2.ESPECIALIZACAO1, D2.END_CIDADE
FROM DENTISTA D2
WHERE D2.CPF = '44455566677');
--Print consultórios pelos seus CEP
CREATE OR REPLACE PROCEDURE get_consultorios_by_cep (cep_in CONSULTORIO.CEP%TYPE) IS
    CURSOR cur_consultorios IS 
        SELECT NOME 
        FROM CONSULTORIO
        WHERE CEP = cep_in;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nomes dos consultórios pelo CEP ' || cep_in || ':');
    FOR reg_cursor IN cur_consultorios LOOP
        DBMS_OUTPUT.PUT_LINE('Consultório: ' || reg_cursor.NOME);
    END LOOP;
END;

--Gatilho para impedir que um funcionário seja chefe de si mesmo
CREATE OR REPLACE TRIGGER check_funcionario_chefe
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW    
BEGIN 
    IF :NEW.CHEFE = :NEW.CPF THEN
        RAISE_APPLICATION_ERROR(-20000, 'O chefe não pode ser ele mesmo!!');
    END IF;
END;

--Função a qual conforme CPF do paciente
CREATE OR REPLACE FUNCTION qtd_consultas (CPF PACIENTE.CPF%TYPE) RETURN NUMBER IS
  qtd NUMBER;
BEGIN 
    SELECT COUNT(*) INTO qtd 
    FROM CONSULTA
    WHERE CPF_PACIENTE = CPF;
    RETURN qtd;
END;

--Gatilho verifica se o CRO do documento é diferente do CRO associado à consulta pela qual foi gerado
CREATE OR REPLACE TRIGGER check_cro_consulta
BEFORE INSERT ON DOCUMENTO
FOR EACH ROW
DECLARE
    v_cro_consulta VARCHAR2(14);
BEGIN
    -- Obtenha o CRO associado à consulta pela qual o documento está sendo gerado
    SELECT REGISTRO
    INTO v_cro_consulta
    FROM CONSULTA
    WHERE CEP = :NEW.CEP AND ENDERECO = :NEW.ENDERECO AND NUM_SALA = :NEW.NUM_SALA AND CPF_DENTISTA = :NEW.CPF_DENTISTA AND CPF_PACIENTE = :NEW.CPF_PACIENTE AND MOMENTO_CONSULTA = :NEW.MOMENTO_CONSULTA;

    -- Verifique se o CRO do documento é diferente do CRO associado à consulta
    IF v_cro_consulta <> :NEW.REGISTRO THEN
        RAISE_APPLICATION_ERROR(-20001, 'O documento não pode ser registrado com um CRO diferente do associado à consulta!');
    END IF;
END;
/
--Função para contar a quantidade de consultas realizadas por um paciente:
CREATE OR REPLACE FUNCTION qtd_consultas_paciente(CPF_paciente_param VARCHAR) RETURN NUMBER IS 
    qtd NUMBER;
BEGIN
    SELECT COUNT(*) INTO qtd
    FROM CONSULTA
    WHERE CPF_PACIENTE = CPF_paciente_param;
    
    RETURN qtd;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Retorna 0 se não houver dados encontrados
END;
/
--Função para contar a quantidade de documentos prescritos por um dentista:
CREATE OR REPLACE FUNCTION qtd_documentos_dentista(CPF_dentista_param VARCHAR) RETURN NUMBER IS 
    qtd NUMBER;
BEGIN
    SELECT COUNT(*) INTO qtd
    FROM DOCUMENTO
    WHERE CPF_DENTISTA = CPF_dentista_param;
    
    RETURN qtd;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Retorna 0 se não houver dados encontrados
END;
/

DECLARE
    v_qtd_consultas NUMBER;
    v_qtd_documentos NUMBER;
BEGIN
    -- Chamando o procedimento para imprimir os consultórios pelo CEP
    get_consultorios_by_cep('12345678');
    
    -- Chamando a função para contar a quantidade de consultas de um paciente
    v_qtd_consultas := qtd_consultas('11122233333');
    DBMS_OUTPUT.PUT_LINE('Quantidade de consultas do paciente: ' || v_qtd_consultas);
    
    -- Chamando a função para contar a quantidade de documentos prescritos por um dentista
    v_qtd_documentos := qtd_documentos_dentista('44455566677');
    DBMS_OUTPUT.PUT_LINE('Quantidade de documentos prescritos pelo dentista: ' || v_qtd_documentos);
END;
/



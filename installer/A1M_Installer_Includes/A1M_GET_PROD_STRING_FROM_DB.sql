
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_GET_PROD_STRING_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER  AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  vprod product%rowtype;
  Vstring Varchar(1000);
  --Vsubmarks Integer :=0;
  

Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'GET_PROD_STRING_FROM_DB';

  If Vcount <> 0 Then
    Dopl('GET_PROD_STRING_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
  
    -- CHECK FOR CORRECT FUNCTION WITH GOOD DATA
    begin
        -- CLEAR THE PRODUCT TABLE
        DELETE FROM SALE;
        Delete From PRODUCT;
      
        -- ADD KNOWN PRODUCT
        Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                    Values (305, 'Test Prod 1', 10, 234);
  
        EXECUTE IMMEDIATE  'CALL ' || USER || '.GET_PROD_STRING_FROM_DB(305) INTO :vstring' USING OUT vstring;
        VSTRING := UPPER(VSTRING);
  
        -- CHECK THE OUTPUT STRING CONTAINS THE CORRECT COMPONENTS.
        
        If Vstring Like '%PRODID%' And
          Vstring Like '%305%' And
          Vstring Like '%NAME%' And
          Vstring Like '%TEST PROD 1%' And
          Vstring Like '%PRICE%' And
          Vstring Like '%10%' And
          ( Vstring Like '%SALESYTD%' OR Vstring Like '%SALES_YTD%') And
          Vstring Like '%234%' Then
         
          Vmarks := Vmarks + 1;
        Else
          dopl('GET_PROD_STRING_FROM_DB CORRECT PROD STRING NOT RETREIVED');
        End If;

    
      Exception
        When Others Then
          Dopl('ERROR WITH GET_PROD_STRING_FROM_DB : ' || SQLERRM );
      End;
  
      -- CHECK FOR PRODUCT NOT FOUND EXCEPTION

    Begin
      -- ensure there are no PRODomes in DB
      delete from sale;
      Delete From PRODUCT;
      
      -- call the function
      EXECUTE IMMEDIATE  'CALL ' || USER || '.GET_PROD_STRING_FROM_DB(500) INTO :vstring' USING OUT vstring;
      
      -- if exception raised this line will not execute
      Dopl('GET_PROD_STRING_FROM_DB DID NOT RAISE EXPECTED EXCEPTION');
    Exception
      When Others Then
        If Sqlcode = -20041 
            And Upper(Sqlerrm) Like '%PRODUCT%'
            And Upper(Sqlerrm) Like '%ID%'
            And Upper(Sqlerrm) Like '%NOT%'
            And Upper(Sqlerrm) Like '%FOUND%' Then
            
          Vmarks := Vmarks + 1;
        Else
          Dopl('GET_PROD_STRING_FROM_DB DID NOT RAISE EXPECTED EXCEPTION ' || SQLERRM);
        End If;
    End;
      
  
  
    -- CHECK IF GET_PROD_STRING_VIASQLDEV
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'GET_PROD_STRING_VIASQLDEV';
  
    If Vcount = 1 Then
       Vmarks := Vmarks + 1;
    Else
    dopl('GET_PROD_STRING_VIASQLDEV EITHER NOT ATTEMPTED OR INCORRECT');
    end if;
  
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR GET_PROD_STRING_FROM_DB AND GET_PROD_STRING_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR IN GET_PROD_STRING_FROM_DB.SQL code - ' || SQLERRM);
End;
/


-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_GET_PROD_STRING_FROM_DB(33));
--END;






set serveroutput on;

-- 3 FOR MAIN 1 FOR VIASQLDEV

CREATE OR REPLACE FUNCTION A1M_ADD_PRODUCT_TO_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  VCOUNT INTEGER;
  Vcount1 Number;
  Vcount2 Integer;
  Vprod Product%Rowtype;
  Vmarks Integer := PSTARTINGMARKS;
  Vsubmark Integer := 0;

Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'ADD_PROD_TO_DB';

  If VCOUNT <> 0 Then
    Dopl('ADD_PROD_TO_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
    -- CLEAR ANY EXISTING PRODUCTS FROM TABLE
    DELETE FROM SALE;
    Delete From Product;
    
    -- ADD A TEST CASE;
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.ADD_PROD_TO_DB(1000, ''Test Product 1'', 10); END;');
    
    
    -- RECOVER THE ADDED PRODUCT
    -- IF PROD NOT EXIST THEN NOT CORRECLT ADDED, SEE DATA_NOT_FOUND EXCEPTION
    Select * Into Vprod From Product
    Where Prodid = 1000;
    
    
    -- CHECK PRODUCT INSERTED
    If Vprod.Prodname = 'Test Product 1' 
       And Vprod.Sales_Ytd = 0 Then
       
      Vmarks := Vmarks + 1;
      Else
      Dopl('ADD_PROD_TO_DB PRODUCT NOT CORRECTLY INSERTED');
    End If;
    
    
    -- CHECK FOR DUP_VAL_ON_INDEX EXCEPTION
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Prod_To_Db(1000, ''Test PRODUCT 2'', 20);END;');
      
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_PROD_TO_DB DID NOT GENERATE DUPLICATE PRODUCT ID EXCEPTION');
      
    Exception
      When Others Then
        If Sqlcode = -20010 -- altered 
           And Upper(Sqlerrm) Like '%DUPLICATE%'
           And Upper(Sqlerrm) Like '%PRODUCT%'
           And Upper(Sqlerrm) Like '%ID%' Then
           
          Vsubmark := Vsubmark + 1;
          
        End If;
    End;
    
    -- CHECK FOR OUT OF RANGE PRODUCT ID
    Begin 
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Prod_To_Db(999, ''Test Product 3'', 30);END;');
      
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_PROD_TO_DB DID NOT GENERATE PRODUCT ID OUT OF RANGE EXCEPTION');
      
    Exception
      When Others Then
        If Sqlcode = -20012 
           And Upper(Sqlerrm) Like '%PRODUCT%'
           And Upper(Sqlerrm) Like '%ID%'
           And Upper(Sqlerrm) Like '%OUT%'
           And Upper(Sqlerrm) Like '%OF%'
           And Upper(Sqlerrm) Like '%RANGE%' Then
           
          vsubmark := vsubmark + 1;
        End If;
    end;
    
    -- CHECK FOR OUT OF RANGE PRICE
    Begin 

     EXECUTE IMMEDIATE ('BEGIN ' || USER || '.ADD_PROD_TO_DB(1001, ''Test Product 4'', 1000);END;');
      
    Exception
      When Others Then
        If Sqlcode = -20013 
          And Upper(Sqlerrm) Like '%PRICE%'
          And Upper(Sqlerrm) Like '%OUT%'
          And Upper(Sqlerrm) Like '%OF%'
          And Upper(Sqlerrm) Like '%RANGE%' Then
          
          vsubmark := vsubmark + 1;
        End If;
    End;
    
    -- if all the excpetions are correct then 2 marks
    If Vsubmark = 3 Then
      Vmarks := Vmarks + 2;
    -- if one of the exceptions is not corect then only 1 mark
    Elsif Vsubmark = 2 Then
      Vmarks := Vmarks + 1;
      dopl('ADD_PROD_TO_DB 1 EXCEPTIONS INCORRECT');
    Else
      dopl('ADD_PROD_TO_DB 2 OR MORE EXCEPTIONS INCORRECT CORRECT');
    end if;
    
    
  -- CHECK THAT ADD_PRODUCT_VIASQLDEV  HAS BEEN ATTEMPTED
    Select Count(*) Into Vcount2 From Sys.All_Objects
    Where Owner = User And Object_Name = 'ADD_PRODUCT_VIASQLDEV';
  
    If Vcount2 = 1  Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('ADD_PRODUCT_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    End If; 
  
      -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/4 Marking points correct FOR ADD_PROD_TO_DB ADD_PRODUCT_VIASQLDEV');
    Return Vmarks;  
  END IF;
  
  

Exception
When No_Data_Found Then
  DOPL('ADD_PROD_TO_DB - PRODUCT NOT INSERTED');
When Others Then
  Dopl('code inspection required - ' || SQLERRM);
End;
/

-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_Add_PROD_To_Db(10));
--END;



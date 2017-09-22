
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_ADD_SIMPLE_SALE_TO_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vcust Customer%Rowtype;
  Vprod Product%Rowtype;
  VSUBMARKS INTEGER :=0;

Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'ADD_SIMPLE_SALE_TO_DB';

  If Vcount <> 0 Then
    Dopl('ADD_SIMPLE_SALE_TO_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
    -- CLEAR THE DATABASE
    DELETE FROM SALE;
    Delete From Customer;
    Delete From Product;
    
    -- INSERT KNOWN DATA
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 120); 
    
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 1', 230, 'OK');
                  
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (333, 'Test Dude 2', 0, 'SUSPEND');
                  
    COMMIT;
                  
      --  TEST WITH CORRECT PARAMETERS
    
    BEGIN
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.ADD_SIMPLE_SALE_TO_DB(222, 1111, 10);   END;');
      
     
      Select * Into Vcust From Customer Where Custid = 222;
      SELECT * INTO VPROD FROM PRODUCT WHERE PRODID = 1111;
     
      If  Vcust.Sales_Ytd = 330 AND  Vprod.Sales_Ytd = 220 Then
        Vmarks := Vmarks + 1;
      Else
        Dopl('ADD_SIMPLE_SALE_TO_DB EITHER CUST SALESYTD OR PROD SALES YTD (OR BOTH) NOT UPDATED CORRECTLY');
      End If;
      
    Exception
      When Others Then
        Dopl('ADD_SIMPLE_SALE_TO_DB THREW AN UNEXPECTED EXCEPTION'); 
    End;
   
    -- TEST WITH WRONG CUST ID 
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Simple_Sale_To_Db(223, 1111, 10);  END;');
      
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_SIMPLE_SALE_TO_DB DID NOT GENERATE CUSTOMER ID NOT FOUND EXCEPTION');
      
     Exception
      When Others Then
        If Sqlcode = -20073 
            And Upper(Sqlerrm) Like '%CUSTOMER%'
            And Upper(Sqlerrm) Like '%ID%' 
            And Upper(Sqlerrm) Like '%NOT%' 
            And Upper(Sqlerrm) Like '%FOUND%' Then
            
            VSUBMARKS := VSUBmarks + 1;
            
        Else
            Dopl('ADD_SIMPLE_SALE_TO_DB INCORRECT CUSTOMER ID NOT FOUND EXCEPTION');
        End If;
     End;
     
      -- TEST WITH WRONG PROD ID     
      Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Simple_Sale_To_Db(222, 1112, 10);  END;');
      
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_SIMPLE_SALE_TO_DB DID NOT GENERATE PRODUCT ID NOT FOUND EXCEPTION');
      
     Exception
      When Others Then
        If Sqlcode = -20076 -- altered 
          And Upper(Sqlerrm) Like '%PRODUCT%'
          And Upper(Sqlerrm) Like '%ID%'
          And Upper(Sqlerrm) Like '%NOT %'
          And Upper(Sqlerrm) Like '%FOUND%' Then
            
            VSUBMARKS := VSUBmarks + 1;

        Else
            Dopl('ADD_SIMPLE_SALE_TO_DB INCORRECT PRODUCT ID NOT FOUND EXCEPTION');
        End If;
     END;
   
      -- TEST WITH CUSTOMER BAD STATUS  
      Begin
      -- TEST WITH CUSTOMER BAD STATUS
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.ADD_SIMPLE_SALE_TO_DB(333, 1111, 10); END;');
      
            
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_SIMPLE_SALE_TO_DB DID NOT GENERATE CUSTOMER STATUS IS NOT OK EXCEPTION');
      
     Exception
      When Others Then
        If Sqlcode = -20072 
          And Upper(Sqlerrm) Like '%CUSTOMER%'
          And Upper(Sqlerrm) Like '%STATUS%' 
          And Upper(Sqlerrm) Like '%IS%' 
          And Upper(Sqlerrm) Like '%NOT%' 
          And Upper(Sqlerrm) Like '%OK%' Then
          
            VSUBMARKS := VSUBmarks + 1;
          
        Else
            Dopl('ADD_SIMPLE_SALE_TO_DB INCORRECT CUSTOMER STATUS IS NOT OK EXCEPTION');
        End If;
     End;
     
     Begin
      -- TEST WITH BAD SALE QTY
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.ADD_SIMPLE_SALE_TO_DB(222, 1111, 1000);END;');
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      Dopl('ADD_SIMPLE_SALE_TO_DB DID NOT GENERATE SALE QTY OUTSIDE VALID RANGE EXCEPTION');
      
     Exception
      When Others Then
        If Sqlcode = -20071 
           And Upper(Sqlerrm) Like '%SALE%' 
           And Upper(Sqlerrm) Like '%QUANTITY%' 
           And Upper(Sqlerrm) Like '%OUTSIDE%'
           And Upper(Sqlerrm) Like '%VALID%'
           And Upper(Sqlerrm) Like '%RANGE%' Then
           
            VSUBMARKS := VSUBmarks + 1;

        Else
            Dopl('ADD_SIMPLE_SALE_TO_DB INCORRECT SALE QTY OUTSIDE VALID RANGE EXCEPTION');
        End If;
     End;     
                               

     If Vsubmarks = 4 Then
        Vmarks := Vmarks +2;
     Elsif Vsubmarks = 3 Then
        Dopl('ADD_SIMPLE_SALE_TO_DB 1 EXCEPTION ERROR');
        Vmarks := Vmarks +1;
     Elsif Vsubmarks = 2 Then
        Dopl('ADD_SIMPLE_SALE_TO_DB 2 EXCEPTION ERRORS');
        Vmarks := Vmarks +1;
     Else 
        Dopl('ADD_SIMPLE_SALE_TO_DB 3 OR MORE EXCEPTION ERRORS');
     END IF;

  -- CHECK FOR ADD_SIMPLE_SALE_VIASQLDEV

  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = 'ADD_SIMPLE_SALE_VIASQLDEV';
  
  If Vcount = 1 Then
    Vmarks := Vmarks + 1;
  Else
    Dopl('ADD_SIMPLE_SALE_VIASQLDEV EITHER NOT ATTEMPTED ON INCORRECT');
  END IF;

      -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/4 Marking points correct FOR ADD_SIMPLE_SALE_TO_DB ADD_SIMPLE_SALE_VIASQLDEV');
    Return Vmarks;  
  END IF;
    
Exception
When Others Then
Dopl('code inspection required - ' || SQLERRM);
End;
/

-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_ADD_SIMPLE_SALE_TO_DB(31));
--END;


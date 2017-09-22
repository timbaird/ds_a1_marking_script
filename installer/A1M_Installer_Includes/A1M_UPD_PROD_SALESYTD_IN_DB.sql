
set serveroutput on;



CREATE OR REPLACE FUNCTION A1M_UPD_PROD_SALESYTD_IN_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vcust Customer%Rowtype;
  vprod product%rowtype;
  Vstring Varchar(1000);
  Vsubmarks Integer :=0;
  

Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'UPD_PROD_SALESYTD_IN_DB';

  If Vcount <> 0 Then
    Dopl('UPD_PROD_SALESYTD_IN_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE 



  begin
  
      -- clear the product table;
      DELETE FROM SALE;
      Delete From product;

      -- insert a known number of productss.
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 111, 340); 
    

       EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Prod_Salesytd_In_Db(1111, -230);END;');
      
    
      select * into vprod from product where prodid = 1111;
    
      If Vprod.Sales_Ytd = 110 Then
          Vmarks := Vmarks +1;
      Else
        Dopl('UPD_PROD_SALESYTD_IN_DB UPDATE INCORRECT');
      End If;
  
  Exception
      When Others Then
        dopl('UPD_PROD_SALESYTD_IN_DB GENERATED UNEXPECTED EXCEPTION');
    
  END;
    
    
    -- TEST EXCEPTIONS
  Begin
        -- test for product id not found
        EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Prod_Salesytd_In_Db(1222, 230);END;');
        
        
       -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
       dopl('UPD_PROD_SALESYTD_IN_DB DID NOT GENERATE PROD ID NOT FOUND EXCEPTION');
  Exception
      When Others Then
          If Sqlcode = -20041 -- altered
            And Upper(Sqlerrm) Like '%PRODUCT%'
            And Upper(Sqlerrm) Like '%ID%' 
            And Upper(Sqlerrm) Like '%NOT%' 
            And Upper(Sqlerrm) Like '%FOUND%' Then
          
              Vsubmarks := Vsubmarks + 1;
          Else
          
          Dopl('UPD_PROD_SALESYTD_IN_DB GENERATED INCORRECT PROD ID NOT FOUND EXCEPTION');
          
          End If;
  end;
      
  Begin
        -- test for PAMT OUT OF RANGE
        EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Prod_Salesytd_In_Db(1111, -1000);END;');
        
        
        -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
        dopl('UPD_PROD_SALESYTD_IN_DB DID NOT GENERATE AMOUNT OUT OF RANGE EXCEPTION');
      
  Exception
        When Others Then
            If Sqlcode = -20052
               And Upper(Sqlerrm) Like '%AMOUNT%'
               And Upper(Sqlerrm) Like '%OUT%' 
               And Upper(Sqlerrm) Like '%OF%'
               And Upper(Sqlerrm) Like '%RANGE%' Then
               
              Vsubmarks := Vsubmarks + 1;
            Else
              dopl('UPD_PROD_SALESYTD_IN_DB GENERATED INCORRECT AMOUNT OUT OF RANGE EXCEPTION');
              
            End If;
  End;

  If Vsubmarks = 2 Then
      Vmarks := Vmarks + 1;
  Else
      dopl('1 OR MORE EXCEPTIONS INCORRECT');
  End If;
 
 
  -- CHECK UPD_PROD_SALESYTD_VIASQLDEV
  
  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = 'UPD_PROD_SALESYTD_VIASQLDEV';
  
  If Vcount = 1 Then
    Vmarks := Vmarks + 1;
  Else
    Dopl('UPD_PROD_SALESYTD_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
  end if; 
  
    -- output the marks    
  Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR UPD_PROD_SALESYTD_IN_DB AND UPD_PROD_SALESYTD_VIASQLDEV');
  Return Vmarks;  
  
END IF;
    
Exception
When Others Then
Dopl('ERROR IN UPD_PROD_SALESYTD_IN_DB : - ' || SQLERRM);
End;
/

-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_UPD_PROD_SALESYTD_IN_DB(4));
--END;

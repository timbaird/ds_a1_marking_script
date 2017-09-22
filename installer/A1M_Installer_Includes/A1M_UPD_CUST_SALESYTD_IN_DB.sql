
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_UPD_CUST_SALESYTD_IN_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vcust Customer%Rowtype;
  vprod product%rowtype;
  Vstring Varchar(1000);
  Vsubmarks Integer :=0;
  

Begin 


 SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'UPD_CUST_SALESYTD_IN_DB';

  If Vcount <> 0 Then
    Dopl('UPD_CUST_SALESYTD_IN_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE 
    
    Begin
    
      -- CLEAR THE CUSTOMER TABLE
      DELETE FROM SALE;
      Delete From Customer;
      -- ADD KNOWN CUSTOMER
      Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (355, 'Test Dude 1', 666, 'SUSPEND');
    
          Select * Into Vcust From Customer Where Custid = 355;
    
        dopl('custid: ' || vcust.custid || ' sales_ytd ' || vcust.sales_ytd);
    
    
      -- TEST UPDATE 
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Cust_Salesytd_In_Db(355, -123); END;');
      
    
      Select * Into Vcust From Customer Where Custid = 355;
    
        dopl('custid: ' || vcust.custid || ' sales_ytd ' || vcust.sales_ytd);
    
    
      If Vcust.Sales_Ytd = 543 Then
        Vmarks := Vmarks + 1;
      Else
        Dopl('UPD_CUST_SALESYTD_IN_DB UPDATE INCORRECT');
      End If;
  
    Exception
      When Others Then
        dopl('UPD_CUST_SALESYTD_IN_DB GENERATED UNEXPECTED EXCEPTION');
    
    END;
    
    -- TEST FOR EXCEPTIONS
    Begin
      -- TEST FOR NO CUSTOMER UPDATED
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Cust_Salesytd_In_Db(444, 100); END;');
      
      
      -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
      dopl('UPD_CUST_SALESYTD_IN_DB DID NOT GENERATE CUST ID NOT FOUND EXCEPTION');
      
    Exception
      When Others Then
        If Sqlcode = -20021 -- altered 
          And Upper(Sqlerrm) Like '%CUSTOMER%'
          And Upper(Sqlerrm) Like '%ID%'
          And Upper(Sqlerrm) Like '%NOT%'
          And Upper(Sqlerrm) Like '%FOUND%' Then
          
          Vsubmarks := Vsubmarks + 1;
          
          Else
          dopl('UPD_CUST_SALESYTD_IN_DB GENERATED INCORRECT CUST ID NOT FOUND EXCEPTION');

        End If;
      End;
      
    Begin
        -- TEST FOR AMOUNT OUT OF RANGE
        EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Upd_Cust_Salesytd_In_Db(355, 1000);END;');
        
      
        -- THIS WILL ONLY BE EXECUTED IF CORRECT EXCEPTION IS NOT GENERATED. 
        Dopl('UPD_CUST_SALESYTD_IN_DB DID NOT GENERATE AMOUNT OUT OF RANGE EXCEPTION');
      
    Exception
        When Others Then
          If Sqlcode = -20032 
            And Upper(Sqlerrm) Like '%AMOUNT%'
            And Upper(Sqlerrm) Like '%OUT%'
            And Upper(Sqlerrm) Like '%OF%'
            And Upper(Sqlerrm) Like '%RANGE%' Then
           
            Vsubmarks := Vsubmarks + 1;
          
          Else
            dopl('UPD_CUST_SALESYTD_IN_DB GENERATED INCORRECT AMOUNT OUT OF RANGE EXCEPTION');
          End If;
      End;  
    
    If Vsubmarks = 2 Then
        Vmarks := Vmarks + 1;
    Else
        dopl('1 OR MORE EXCEPTIONS INCORRECT');
    End If;
          

    -- CHECK UPD_CUST_SALESYTD_VIASQLDEV
    
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And  Object_Name = 'UPD_CUST_SALESYTD_VIASQLDEV';
  
    If Vcount = 1 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('UPD_CUST_SALESYTD_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    end if; 
  
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR UPD_CUST_SALESYTD_IN_DB AND UPD_CUST_SALESYTD_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR IN code inspection required - ' || SQLERRM);
End;
/

-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_UPD_CUST_SALESYTD_IN_DB(17));
--END;


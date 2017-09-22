
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_ADD_COMPLEX_SALE_TO_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := Pstartingmarks;
  VSUBMARKS INTEGER := 0;
  Vsalesytd Number;
  Vcust Customer%Rowtype;
  Vprod Product%Rowtype;
  Vsale Sale%Rowtype;
  vcur sys_refcursor;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'ADD_COMPLEX_SALE_TO_DB';

  If Vcount <> 0 Then
    Dopl('ADD_COMPLEX_SALE_TO_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
    
    -- clear data from tables
    delete frOm sale;
    Delete From Customer;
    Delete From Product;

    
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 0, 'OK');
                  
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 2', 0, 'SUSPEND');
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 50); 
    
    -- TEST GOOD INSERT
    
    begin
    
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db(221, 1111, 10, ''20140920''); END;');
      
    
      Select * Into Vcust From Customer Where Custid = 221;
      Select * Into Vprod From Product Where Prodid = 1111;
      Select * Into Vsale From Sale Where Custid = 221;
    
      If Vcust.Sales_Ytd = 100 
        And Vprod.Sales_Ytd = 150
        And Vsale.Custid = 221
        And Vsale.Prodid = 1111
        AND VSALE.QTY = 10
        
        -- TWO VERSION OF NEXT STATEMENT PROVIDED TO ALLOW FOR DIFFERENT ASSUMPTIONS
        -- COMMENT OUT THE UNDESIRED VERSION
        
        -- ASSUMES IT IS THE UNIT PRICE TO BE INSERTED INTO SALES TABLE PRICE COLUMN
        And Vsale.Price = 10  THEN
        
        -- ASSUMES IT IS THE TOTAL TRANSACTION PRICE THAT IS TO BE INSERTED.
        --AND Vsale.Price = 100 Then
              
      
        Vmarks := Vmarks + 1;
        
      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - CORRECT DATA NOT INSERTED');
      END IF;
    
    Exception
      When Others Then
        Dopl('ADD_COMPLEX_SALE_TO_DB - GENERATED UNEXPECTED EXCEPTION');
    END;
    
    
    
    -- TEST CUSTOMER STATUS NOT OK EXCEPTION
    
    BEGIN
    
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 222, 1111, 10, ''20140920'' ); END;');
      Add_Complex_Sale_To_Db( 222, 1111, 10, '20140920' );
      
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - DID NOT GENERATE CUSTOMER STATUS EXCEPTION');
      
    Exception
      WHEN OTHERS THEN
      If Sqlcode = -20092 
         And Upper(Sqlerrm) Like '%CUSTOMER%'
         And Upper(Sqlerrm) Like '%STATUS%'
         And Upper(Sqlerrm) Like '%NOT%'
         And Upper(Sqlerrm) Like '%OK%' Then
         
        Vsubmarks := Vsubmarks + 1;

      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - CUSTOMER STATUS IS NOT OK EXCEPTION INCORRECT');
      End If;
      
    End;
    
    -- CHECK SALE QTY RANGE EXCEPTION
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 221, 1111, 1000, ''20140920'' ); END;');
      
      
       -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - SALE QTY OUTSIDE VALID RANGE EXCEPTION NOT RAISED');
      
    Exception
      WHEN OTHERS THEN
      If Sqlcode = -20091 
         And Upper(Sqlerrm) Like '%SALE%'
        And Upper(Sqlerrm) Like '%QUANTITY%'
        And Upper(Sqlerrm) Like '%OUTSIDE%'
        And Upper(Sqlerrm) Like '%VALID%'
        And Upper(Sqlerrm) Like '%RANGE%' Then
        
        Vsubmarks := Vsubmarks + 1;
        
      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - SALE QTY OUTSIDE VALID RANGE EXCEPTION INCORRECT');
      End If;
    
    End;
    
    -- CHECK DATE NOT VALID - INCORRECT LENGTH
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 221, 1111, 900, ''201409201'' ); END;');
      
      
     -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG LENGTH)');
      
    Exception
      WHEN OTHERS THEN    
      If Sqlcode = -20093 
          And Upper(Sqlerrm) Like '%DATE%'
          And Upper(Sqlerrm) Like '%NOT%'
          And Upper(Sqlerrm) Like '%VALID%' Then
          
        VSUBmarks := VSUBmarks + 1;

      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG LENGTH)');
      End If;
    
    End;
    
    
        
    -- CHECK DATE NOT VALID - BAD MONTH VALUE
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 221, 1111, 900, ''20141320'' ); END;');
      
      
     -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG MONTH)');
      
    Exception
      WHEN OTHERS THEN    
      If Sqlcode = -20093 
          And Upper(Sqlerrm) Like '%DATE%'
          And Upper(Sqlerrm) Like '%NOT%'
          And Upper(Sqlerrm) Like '%VALID%' Then
          
        VSUBmarks := VSUBmarks + 1;

      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG MONTH)');
      End If;
    
    End;
    
    -- CHECK DATE NOT VALID - BAD DAY VALUE
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 221, 1111, 900, ''201409232'' ); END;');
      
      
     -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG DAY)');
      
    Exception
      WHEN OTHERS THEN    
      If Sqlcode = -20093 
          And Upper(Sqlerrm) Like '%DATE%'
          And Upper(Sqlerrm) Like '%NOT%'
          And Upper(Sqlerrm) Like '%VALID%' Then
          
        VSUBmarks := VSUBmarks + 1;

      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB - DATE NOT VALID EXCEPTION INCORRECT (WRONG DAY)');
      End If;
    
    End;
    
    -- CHECK CUSTOMER ID NOT FOUND EXCEPTION
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 220, 1111, 900, ''20140920'' ); END;');
      
      
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - CUSTOMER ID NOT FOUND EXCEPTION NOT RAISED');
      
    Exception
      When Others Then
      If Sqlcode = -20094 
         And Upper(Sqlerrm) Like '%CUSTOMER%'
         And Upper(Sqlerrm) Like '%ID%'
         And Upper(Sqlerrm) Like '%NOT%'
         And Upper(Sqlerrm) Like '%FOUND%' Then
         
        Vsubmarks := Vsubmarks + 1;

      Else
      
        Dopl('ADD_COMPLEX_SALE_TO_DB - CUSTOMER ID NOT FOUND EXCEPTION INCORRECT');
      End If;
    End;
    
    -- CHECK PRODUCT ID NOT FOUND EXCEPTION
    
    
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Complex_Sale_To_Db( 221, 1112, 900, ''20140920'' ); END;');
      
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_COMPLEX_SALE_TO_DB - PRODUCT ID NOT FOUND EXCEPTION NOT RAISED');
    Exception
      WHEN OTHERS THEN
      If Sqlcode = -20095 
         And Upper(Sqlerrm) Like '%PRODUCT%'
         And Upper(Sqlerrm) Like '%ID%'
         And Upper(Sqlerrm) Like '%NOT%'
         And Upper(Sqlerrm) Like '%FOUND%' Then
         
        VSUBmarks := VSUBmarks + 1;
        
      Else
        Dopl('ADD_COMPLEX_SALE_TO_DB PRODUCT ID NOT FOUND EXCEPTION INCORRECT');
      End If;
    
    End;
    
    -- 8 TESTING POINTS IN EXCEPTION TESTING (IE SUBMARKS) - 3 FULL MARKS TO BE AWARDED
    
    If Vsubmarks > 6 Then
      Vmarks := Vmarks + 3;
    Elsif Vsubmarks >= 4 Then
     Vmarks := Vmarks + 2;
     Dopl( 7 - Vsubmarks || ' OF 7 EXCEPTION TESTING POINTS FAILED');
    Elsif Vsubmarks >= 2 Then
     Vmarks := Vmarks + 1; 
     Dopl( 7 - Vsubmarks || ' OF 7 EXCEPTION TESTING POINTS FAILED');
    Else
     Dopl( 7 - Vsubmarks || ' OF 7 EXCEPTION TESTING POINTS FAILED'); 
    END IF;
    
  
    -- CHECK ADD_COMPLEX_SALE_VIASQLDEV
  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = 'ADD_COMPLEX_SALE_VIASQLDEV';
  
  If Vcount = 1 Then
    VMARKS := VMARKS +1;
  Else
    Dopl('ADD_COMPLEX_SALE_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/5 Marking points correct FOR ADD_COMPLEX_SALE_TO_DB AND ADD_COMPLEX_SALE_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
    
Exception
When Others Then
Dopl('ADD_COMPLEX_SALE_TO_DB GENERATED UNEXPECTED EXCEPTION - ' || SQLERRM);
End;
/

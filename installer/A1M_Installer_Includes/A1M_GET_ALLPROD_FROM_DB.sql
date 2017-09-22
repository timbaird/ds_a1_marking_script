
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_GET_ALLPROD_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vprod Product%Rowtype;
  Vcur Sys_Refcursor;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'GET_ALLPROD_FROM_DB';

  If Vcount <> 0 Then
    Dopl('GET_ALLPROD_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE  
  
   begin

      -- clear all PRODUCTS
      DELETE FROM SALE;
      Delete From product;
      
      -- add known products
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 100); 
                  
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1112, 'Test Product 2', 10, 120); 
                  
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1113, 'Test Product 3', 10, 100); 
                  
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1114, 'Test Product 4', 10, 120); 
                  
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1115, 'Test Product 5', 10, 100); 
                  
      Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1116, 'Test Product 6', 10, 120); 

      EXECUTE IMMEDIATE  'CALL ' || USER || '.Get_Allprod_From_Db() INTO :Vcur' USING OUT Vcur;
     
      Vcount := 0;
      
        Loop
          Fetch Vcur Into Vprod;
            Exit When Vcur%Notfound;
            vCount := vCount +1;
        End Loop;
      
      If Vcount = 6 Then
        Vmarks := Vmarks + 3;
      Else
        Dopl('GET_ALLPROD_FROM_DB - CORRECT CURSOR NOT RETURNED');
      End If;
  exception
    When Others Then
      Dopl('GET_ALLPROD_FROM_DB GENERATED UNEXPECTED EXCEPTION' || Sqlerrm);
  end;   
    
    -- CHECK FOR GET_ALLPROD_VIASQLDEV
    
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'GET_ALLPROD_VIASQLDEV' ;
  
    If  Vcount = 1 Then
      VMARKs := VMARKs + 4;
    Else
      Dopl('GET_ALLPROD_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/7 Marking points correct FOR GET_ALLPROD_FROM_DB AND GET_ALLPROD_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR MARKING GET_ALLPROD_FROM_DB  - ' || SQLERRM);
End;
/



set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_DELETE_PROD_FROM_DB(PSTARTINGMARKS NUMBER)RETURN NUMBER AUTHID CURRENT_USER AS

VCOUNT INTEGER;
Vcust Customer%Rowtype;
Vmarks Integer := PSTARTINGMARKS;
Vcount1 Integer;
Vcount2 Integer;
VSUBMARK INTEGER := 0;

BEGIN

  -- 2 MARKS ALLOCATED
  
  -- 1 MARK FOR CORRECTLY DELETEING PRODUCT
  -- 1 MARK FOR BOTH EXCEPTIONS CORRECT
  -- 0 MARKS FOR VIASQLDEV

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_PROD_FROM_DB';

  If Vcount <> 0 Then
    Dopl('DELETE_PROD_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE


  -- Clear TABLES AND ADD TEST DATA
  Delete From Sale;
  Delete From Customer;
  Delete From Product;

  COMMIT;
  
  Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 100, 'OK');
                  
  Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 2', 250, 'OK');
                  
  Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 50);
  
  Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1112, 'Test Product 2', 15, 150);
                  
  Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(5, 221, 1111, 10, 12, SYSDATE);
                  
  
  Begin
    -- CHECK FOR CORRECT DELETE
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.DELETE_PROD_FROM_DB(1112);END;');
    
    
    Select Count(*) Into Vcount1 From PRODUCT Where PRODid = 1112;
    SELECT COUNT(*) INTO VCOUNT2 FROM PRODUCT;
    
    
    If Vcount1 = 0 And Vcount2 = 1 Then
    
      VMARKS := VMARKS + 1;
    Else
      Dopl('DELETE_PROD_FROM_DB - PRODUCT NOT DELETED CORRECTLY');
    END IF;
    
  ExcePtion
   When Others Then
       Dopl('DELETE_PROD_FROM_DB - GENERATED UNEXPECTED EXCEPTION');
  END;
  
  Begin
   -- CHECK FOR PRODUCT ID NOT FOUND
   EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Delete_Prod_From_Db(1115);END;');
   
   
   -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
  Dopl('DELETE_PROD_FROM_DB - PRODUCT ID NOT FOUND EXCEPTION NOT RAISED');
  
  Exception
    When Others Then
      If Sqlcode = -20301 
          And Upper(Sqlerrm) Like '%PRODUCT%'
          And Upper(Sqlerrm) Like '%ID%'
          And Upper(Sqlerrm) Like '%NOT%'
          And Upper(Sqlerrm) Like '%FOUND%' Then
          
          Vsubmark := Vsubmark + 1;
          
        Else
          Dopl('DELETE_PROD_FROM_DB - PRODUCT ID NOT FOUND EXCEPTION NOT CORRECT');
      End If;
    
  END;
  
  
  
  Begin
   -- CHECK FOR PRODUCT HAS CHILD ROWS IN SALES TABLE
   EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Delete_Prod_From_Db(1111);END;');
   
   -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
  Dopl('DELETE_PROD_FROM_DB - PRODUCT HAS CHILD ROWS EXCEPTION NOT RAISED');
  
  Exception
    When Others Then
      If Sqlcode = -20302 
         And Upper(Sqlerrm) Like '%PRODUCT%'
         And Upper(Sqlerrm) Like '%CANNOT%'
         And Upper(Sqlerrm) Like '%DELETED%'
         And Upper(Sqlerrm) Like '%SALES%'
         And Upper(Sqlerrm) Like '%EXIST%' Then
         
          Vsubmark := Vsubmark + 1;
          
        Else
          Dopl('DELETE_PROD_FROM_DB - PRODUCT HAS CHILD ROWS EXCEPTION NOT CORRECT');
      End If;
    
  END;
  
    If Vsubmark = 2 Then
    Vmarks := Vmarks + 1;
  Else
     Dopl('DELETE_PROD_FROM_DB -  ONE OR MORE EXCPETION INCORRECT');
  End If;


  -- CHECK IF function / procedure exists
  Select Count(*) Into Vcount1 From Sys.All_Objects
  Where Owner = User And Object_Name = 'DELETE_PROD_VIASQLDEV' ;
  
  If Vcount1 = 1 Then
    -- DO NOTHING
    VSUBMARK := 0;
  Else
    Dopl('DELETE_PROD_VIASQLDEV - EITHER NOT ATTEMPTED OR NOT CORRECT');
    
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/2 Marking points correct FOR DELETE_PROD_FROM_DB AND DELETE_PROD_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    

Exception
  When Others Then
    Dopl('DELETE_PROD_FROM_DB GENERATED UNEXPECTED EXCEPTION - ' || SQLERRM);
End;
/







set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_DELETE_SALE_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  VCOUNT2 INTEGER;
  Vmarks Integer := PSTARTINGMARKS;
  Vsaleid Sale.Saleid%Type;
  Vcust Customer%Rowtype;
  vprod product%rowtype;
  
Begin

    -- 6 MARKS ALLOCATED
    
    -- 1 FOR DELETEING CORRECT ( min sale id ) SALE ROW
    -- 1 FOR UPDATING SALES YTD FOR CUSTOMER 
    -- 1 FOR UPDATING SALES YTD FOR PRODUCT
    -- 1 FOR CORRECT RETURN VALUE
    -- 1 FOR NO SALE ROWS FOUND EXCEPTION
    -- 1 FOR DELETE_SALE_VIASQLDEV


  -- CHECK IF APPROPRIATELY NAMED PROCEDURE EXISTS
  
  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_SALE_FROM_DB';

  If Vcount <> 0 Then
    Dopl('DELETE_SALE_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
  
    -- CLEAR TABLES
  Delete From Sale;
  Delete From Customer;
  Delete From Product;
    
  -- CHECK FOR NO SALE ROWS FOUND ERROR
  Begin
  
    EXECUTE IMMEDIATE  'CALL ' || USER || '.Delete_Sale_From_Db() 
                        INTO :Vsaleid' USING OUT Vsaleid;
      
    -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
    Dopl('DELETE_SALE_FROM_DB - NO SALE ROWS FOUND EXCEPTION NOT RAISED');
      
  Exception
    When Others Then
      If Sqlcode = -20101 
          And Upper(Sqlerrm) Like '%NO%'
          And Upper(Sqlerrm) Like '%SALE%'
          And Upper(Sqlerrm) Like '%ROWS%'
          And Upper(Sqlerrm) Like '%FOUND%' Then
           
          Vmarks := Vmarks + 1;
          
      Else
          Dopl('DELETE_SALE_FROM_DB - NO SALE ROWS FOUND EXCEPTION INCORRECT');
      End If;
  END;
      
    -- TEST FOR CORRECTNESS OF OTHER MARKING POINTS
  Begin
      

    -- INSERT KNOWN DATA
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 746, 'OK');
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 12, 746); 
      
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  Values(5, 221, 1111, 11, 6, Sysdate);
      
    -- THIS MAKES A SALEYTD VALUE OF 66
                          
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(8, 221, 1111, 19, 2, SYSDATE);               
      
    -- THIS MAKES A SALEYTD VALUE OF 38
      
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(12, 221, 1111, 2, 321, SYSDATE);               
      
    -- THIS MAKES A SALEYTD VALUE OF 642
      
    -- TOTAL SALESYTD OF 642 + 38 + 66 = 746
    -- AFTER DELETION OF SALE 5 SHOULD BE SALESYTD 746 - 66 = 680
     
    -- SHOULD DELETE SALE WITH SALEID 5
    EXECUTE IMMEDIATE  'CALL ' || USER || '.Delete_Sale_From_Db() 
                        INTO :Vsaleid' USING OUT Vsaleid;
      
    -- CHECK RETURN VALUE ID CORRECT
    If Vsaleid = 5 Then
        Vmarks := Vmarks + 1;
    Else
        Dopl('DELETE_SALE_FROM_DB - RETURN VALUE INCORRECT');
    End If;
      
      
    -- CHECK SALE 5 DELETED CORRECTLY
    Select Count(*) Into Vcount From Sale Where Saleid = 5;
    SELECT COUNT(*) INTO VCOUNT2 FROM SALE;
      
    If Vcount = 0  -- SALE 5 DELETED
        AND VCOUNT2 = 2 -- ONLY ONE SALE DELETED
        Then
         
        Vmarks := Vmarks + 1;
         
    Else
        Dopl('DELETE_SALE_FROM_DB - SALE NOT CORRECTLY DELETED');
    End If;      
         
      
    Select * Into Vcust From Customer Where Custid = 221;
    Select * Into Vprod From Product Where Prodid = 1111;

      
    If  Vcust.Sales_Ytd = 680 Then
        Vmarks := Vmarks + 1;
    Else
        Dopl('DELETE_SALE_FROM_DB - CUSTOMER SALESYTD NOT CORRECTLY UPDATED');
    End If;    


    If Vprod.Sales_Ytd = 680 Then
        Vmarks := Vmarks + 1;
    Else
        Dopl('DELETE_SALE_FROM_DB - PRODUCT SALESYTD NOT CORRECTLY UPDATED');
    End If;    

  END;
    

    
      -- CHECK DELETE_SALE_VIASQLDEV
  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = 'DELETE_SALE_VIASQLDEV';
  
  If Vcount = 1 Then
    Vmarks := Vmarks + 1;

  Else
    Dopl('DELETE_SALE_VIASQLDEV - EITHER NOT ATTEMPTED OR INCORRECT');
    
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/6 Marking points correct FOR DELETE_SALE_FROM_DB AND DELETE_SALE_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    

Exception
  When Others Then
    Dopl('DELETE_SALE_FROM_DB GENERATED UNEXPECTED EXCEPTION - ' || SQLERRM);
End;
/

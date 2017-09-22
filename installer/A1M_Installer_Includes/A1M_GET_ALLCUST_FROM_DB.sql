SET serveroutput on;


CREATE OR REPLACE FUNCTION A1M_GET_ALLCUST_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := 0;
  Vcust Customer%Rowtype;
  Vcur Sys_Refcursor;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'GET_ALLCUST';

  If Vcount <> 0 Then
    Dopl('GET_ALLCUST NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
  
  begin
      -- clear all customers
      DELETE FROM SALE;
      Delete From Customer;
      
      -- add known customers
      
      Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (1, 'Test Dude 1', 0, 'OK');
              
      Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (2, 'Test Dude 2', 0, 'OK');
              
      Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (3, 'Test Dude 3', 0, 'OK');
      
      EXECUTE IMMEDIATE  'CALL ' || USER || '.Get_Allcust() INTO :Vcur' USING OUT Vcur;

      Vcount := 0;
      
        Loop
          Fetch Vcur Into Vcust;
            Exit When Vcur%Notfound;
              Vcount := Vcount +1;
        End Loop;

      
      If Vcount = 3 Then
        Vmarks := Vmarks + 4;
      Else
        Dopl('GET_ALLCUST CORRECT CURSOR NOT RETURNED');
      End If;

  exception
      When Others Then
        Dopl('GET_ALLCUST GENERATED UNEXPECTED EXCEPTION - ' || Sqlerrm);
  end;
    
-- CHECK FOR GET_ALLCUST_VIASQLDEV

    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'GET_ALLCUST_VIASQLDEV';
  
    If Vcount = 1 Then
      VMARKs := VMARKs + 4;
    Else
      Dopl('GET_ALLCUST_VIASQLDEV EITHER NOT ATTEMPTED OR INCORRECT');
    End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/8 Marking points correct FOR GET_ALLCUST AND GET_ALLCUST_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
    
Exception
When Others Then
Dopl('ERROR MARKING GET_ALLCUST - ' || SQLERRM);
End;
/
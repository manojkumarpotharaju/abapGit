*&---------------------------------------------------------------------*
*& Report Y229_PRACTICE
*&---------------------------------------------------------------------*
*& ***************  Practice codes *************
*&---------------------------------------------------------------------*
REPORT y229_practice.
********-------******** Prime Number *********-------*************
*DATA: gv_num  TYPE i,
*      gv_res  TYPE p,
*      gv_pnum TYPE p,
*      gv_tag  TYPE i.
*SELECTION-SCREEN BEGIN OF BLOCK b1.
*  PARAMETERS : p_num TYPE i.
*SELECTION-SCREEN END OF BLOCK b1.
*gv_pnum = 1.
*WHILE gv_pnum LE p_num.
*  gv_num = 2.
*  gv_tag = 0.
*  WHILE gv_num < gv_pnum.
*    gv_res = gv_pnum MOD gv_num.
*    IF gv_res = 0.
*      WRITE: / gv_pnum.
*      WRITE: 'is not prime number' COLOR 3 INTENSIFIED OFF.
*      gv_tag = 1.
*      EXIT.
*    ENDIF.
*    gv_num = gv_num + 1.
*  ENDWHILE.
*  IF gv_tag = 0.
*    WRITE: / gv_pnum.
*    WRITE:'is prime number' COLOR 6 INTENSIFIED OFF.
*  ENDIF.
*  gv_pnum = gv_pnum + 1.
*ENDWHILE.
*
***********------****** Armstrong number ******------*********
*
*PARAMETERS p_num TYPE n LENGTH 3.
*DATA gv_sum TYPE i.
*gv_sum = p_num(1) ** 3 + p_num+1(1) ** 3 + p_num+2(1) ** 1.
*IF p_num = gv_sum.
*  WRITE: gv_sum, 'Armstrong Number'.
*ELSE.
*  WRITE: gv_sum, 'Not a Armstrong Number'.
*ENDIF.
*
*PARAMETERS p_num TYPE i.
*DATA : gv_no  TYPE i,
*       gv_rem TYPE i,
*       gv_res TYPE i.
*gv_no = p_num.
*WHILE p_num GT 0.
*  gv_rem = p_num MOD 10.
*  gv_res = gv_res + gv_rem * gv_rem * gv_rem.
*  p_num = ( p_num ) DIV 10.
*ENDWHILE.
*IF gv_no EQ gv_res.
*  WRITE 'armstrong'.
*ELSE.
*  WRITE 'not armstrong'.
*ENDIF.
*
*********-------******* EVEN or ODD ******--------*******
*
*PARAMETERS: p_num TYPE i.
*IF p_num IS INITIAL.
*  MESSAGE 'Input cannot be empty' TYPE 'I'.
*ELSEIF p_num MOD 2 EQ 0.
*  WRITE 'EVEN'.
*ELSEIF  p_num MOD 2 <> 0.
*  WRITE 'ODD'.
*ENDIF.
*
*******-----****** Reverse of a String *****------********
*
*PARAMETERS: p_str(10) TYPE c.
*DATA : gv_str(10) TYPE c.
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    string  = p_str
*    lang    = sy-langu
*  IMPORTING
*    rstring = gv_str
** EXCEPTIONS
**   TOO_SMALL       = 1
**   OTHERS  = 2
*  .
*IF sy-subrc EQ 0.
*  WRITE: gv_str.
*ENDIF.
*
*******-----******* Palindrome ****-------********
*
*PARAMETERS: p_str(10) TYPE c.
*DATA: gv_str(10) TYPE c.
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    string  = p_str
*    lang    = sy-langu
*  IMPORTING
*    rstring = gv_str
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS  = 2
*.
*IF p_str EQ gv_str.
*  WRITE: p_str, gv_str.
*  WRITE: 'Palindrome'.
*ELSE.
*  WRITE: p_str, gv_str.
*  WRITE: 'Not a Palindrome'.
*ENDIF.

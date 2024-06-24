CLASS lhc_sample DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR sample RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR sample RESULT result.

    METHODS create_text FOR MODIFY
      IMPORTING keys FOR ACTION sample~create_text.

    METHODS save FOR MODIFY
      IMPORTING keys FOR ACTION sample~save .
*RESULT result.

    METHODS to_app FOR MODIFY
      IMPORTING keys FOR ACTION sample~to_app.

    METHODS to_text_app FOR MODIFY
      IMPORTING keys FOR ACTION sample~to_text_app.

    METHODS to_app2 FOR MODIFY
      IMPORTING keys FOR ACTION sample~to_app2.
    METHODS file_name FOR MODIFY
      IMPORTING keys FOR ACTION sample~file_name RESULT result.
    METHODS file_name2 FOR MODIFY
      IMPORTING keys FOR ACTION sample~file_name2.
    METHODS save_excel FOR MODIFY
      IMPORTING keys FOR ACTION sample~save_excel.

    METHODS save_json FOR MODIFY
      IMPORTING keys FOR ACTION sample~save_json.

    METHODS save_text FOR MODIFY
      IMPORTING keys FOR ACTION sample~save_text.

    METHODS save_xml FOR MODIFY
      IMPORTING keys FOR ACTION sample~save_xml.

ENDCLASS.

CLASS lhc_sample IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create_text.

    DATA: ls_sample_text TYPE STRUCTURE FOR CREATE zchi_sd_sample,
          lt_sample_text TYPE TABLE FOR CREATE zchi_sd_sample.
    DATA: l_cid LIKE ls_sample_text-%cid.

    SELECT *
    FROM I_SalesDocument INTO TABLE @DATA(lt_sd).
    DATA: lo_uuid TYPE REF TO if_system_uuid,
          l_uuid  TYPE sysuuid_x16.

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd2>).
      lo_uuid = cl_uuid_factory=>create_system_uuid(  ).
      l_uuid = lo_uuid->create_uuid_x16(  ).
      l_cid = l_cid + 1 .
*      ls_sample_text-longstring =  <ls_sd2>-salesdocument && ' /t ' && <ls_sd2>-salesdocument .
      TRY.
          DATA(xstring) = cl_abap_conv_codepage=>create_out( )->convert(  <ls_sd2>-salesdocument && | \t | && <ls_sd2>-salesdocument   ).
        CATCH cx_sy_conversion_codepage INTO DATA(ex).
      ENDTRY.


      ls_sample_text = VALUE #(
                          %cid = l_cid
                          salesdocument = <ls_sd2>-salesdocument
                          salesgroup = <ls_sd2>-salesgroup
*                          ruuid = l_uuid
*                          mimetype = 'text/plain'
*                          filename = 'text.txt'
**                          longstring = ls_sample_text-longstring
*                          attachment = xstring
                          %control = VALUE #(
                                       salesdocument = cl_abap_behv=>flag_changed
                                       salesgroup = cl_abap_behv=>flag_changed
*                                       longstring = cl_abap_behv=>flag_changed
*                                       mimetype = cl_abap_behv=>flag_changed
*                                       filename = cl_abap_behv=>flag_changed
**                                       ruuid = cl_abap_behv=>flag_changed
*                                       attachment = cl_abap_behv=>flag_changed
                                        ) ).
      APPEND ls_sample_text TO lt_sample_text.

    ENDLOOP.

    MODIFY ENTITIES OF zchi_sd_sample IN LOCAL MODE
     ENTITY sample
     CREATE FROM lt_sample_text
     MAPPED DATA(mapped1).

  ENDMETHOD.

  METHOD save.

    DATA: ls_sample_text TYPE STRUCTURE FOR CREATE zchi_sd_sample,
          lt_sample_text TYPE TABLE FOR CREATE zchi_sd_sample.
    DATA: l_cid LIKE ls_sample_text-%cid.
    DATA: lt_sd2 TYPE TABLE FOR DELETE zchi_sd_sample.

    SELECT *
      FROM zch_sd_sample
      INTO CORRESPONDING FIELDS OF TABLE @lt_sd2.

    IF lt_sd2 IS NOT INITIAL.
      MODIFY ENTITIES OF zchi_sd_sample IN LOCAL MODE
       ENTITY sample
       DELETE FROM lt_sd2
       FAILED DATA(delete_failed)
       REPORTED DATA(delete_reported).
    ENDIF.

    SELECT *
      FROM I_SalesDocument AS h
     INNER JOIN I_SalesDocumentItem AS i ON h~SalesDocument = i~SalesDocument
      INTO TABLE @DATA(lt_sd).

    DATA: lo_uuid TYPE REF TO if_system_uuid,
          l_uuid  TYPE sysuuid_x16.

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd2>).
      lo_uuid = cl_uuid_factory=>create_system_uuid(  ).
      l_uuid = lo_uuid->create_uuid_x16(  ).
      l_cid = l_cid + 1 .
*      ls_sample_text-longstring =  <ls_sd2>-salesdocument && ' /t ' && <ls_sd2>-salesdocument .
      TRY.
          DATA(xstring) = cl_abap_conv_codepage=>create_out( )->convert(
          <ls_sd2>-h-SalesDocument
          && | \t | && <ls_sd2>-h-salesgroup
          && | \t | && <ls_sd2>-h-salesdocumentdate
          && | \t | && <ls_sd2>-h-salesorganization
          && | \t | && <ls_sd2>-h-distributionchannel
          && | \t | && <ls_sd2>-h-organizationdivision
          && | \t | && <ls_sd2>-h-transactioncurrency
          && | \t | && <ls_sd2>-i-salesdocumentitem
          && | \t | && <ls_sd2>-i-material ).
        CATCH cx_sy_conversion_codepage INTO DATA(ex).
      ENDTRY.

      ls_sample_text = VALUE #(
                          %cid = l_cid
                          salesdocument = <ls_sd2>-h-salesdocument
                          salesgroup = <ls_sd2>-h-salesgroup
                          salesdocumentitem = <ls_sd2>-i-SalesDocumentItem
                          material         = <ls_sd2>-i-material
                          salesdocumentdate  = <ls_sd2>-h-salesdocumentdate
                          salesorganization   = <ls_sd2>-h-salesorganization
                          distributionchannel = <ls_sd2>-h-distributionchannel
                          organizationdivision = <ls_sd2>-h-organizationdivision
                          transactioncurrency  = <ls_sd2>-h-transactioncurrency

                          %control = VALUE #(
                                       salesdocument = cl_abap_behv=>flag_changed
                                       salesgroup = cl_abap_behv=>flag_changed
                                       salesdocumentitem = cl_abap_behv=>flag_changed
                                       material         = cl_abap_behv=>flag_changed
                                       salesdocumentdate  = cl_abap_behv=>flag_changed
                                       salesorganization   = cl_abap_behv=>flag_changed
                                       distributionchannel = cl_abap_behv=>flag_changed
                                       organizationdivision = cl_abap_behv=>flag_changed
                                       transactioncurrency  = cl_abap_behv=>flag_changed

                                        ) ).
      APPEND ls_sample_text TO lt_sample_text.

    ENDLOOP.

    MODIFY ENTITIES OF zchi_sd_sample IN LOCAL MODE
     ENTITY sample
     CREATE FROM lt_sample_text
     MAPPED DATA(mapped1).

  ENDMETHOD.

  METHOD to_app.

    DATA var TYPE string.
    DATA descript2 TYPE string.
    DATA lt_txt TYPE TABLE FOR CREATE zchr_text.
    DATA: ls_txt TYPE STRUCTURE FOR CREATE zchr_text.
    DATA lt_txt2 TYPE TABLE FOR UPDATE zchr_text.
    DATA: ls_txt2 TYPE STRUCTURE FOR UPDATE zchr_text.
    DATA l_cid TYPE String.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.

    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF zchi_sd_sample  IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_sd).

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd>).
*      l_cid = l_cid + 1.
      IF descript2 IS INITIAL.

        descript2 =  |SalesDocument \t salesgroup  \t salesdocumentdate \t |
          && | salesorganization \t distributionchannel \t organizationdivision \t|
          && | transactioncurrency \t salesdocumentitem \t material \n|
          && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.

      ELSE.
        descript2 = descript2 && |\n| && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.
      ENDIF.



    ENDLOOP.

    TRY.
        DATA(xstring3) = cl_abap_conv_codepage=>create_out( )->convert( descript2 ).
      CATCH cx_sy_conversion_codepage INTO DATA(ex3).
    ENDTRY.

    ls_txt = VALUE #( %cid = '2'
                      salesdocument = <ls_sd>-salesdocument
                      Attachment = xstring3
                      mimetype = 'text/plain'
                      filename = 'text.txt'

                      longString = descript2
                      %control-Attachment = if_abap_behv=>mk-on
                      %control-mimetype = if_abap_behv=>mk-on
                      %control-filename = if_abap_behv=>mk-on
                      %control-longString = if_abap_behv=>mk-on
                      %control-salesdocument = if_abap_behv=>mk-on
                      ).

    APPEND ls_txt TO lt_txt.

    MODIFY ENTITIES OF zchr_text
       ENTITY txt
       CREATE FROM lt_txt
       MAPPED DATA(mapped2).

    ls_file = VALUE #( %cid = '1'
                      FileNO = l_count
                      Attachment = xstring3
                      mimetype = 'text/plain'
                      filename = 'text.txt'
                      longString = descript2
                      %control-Attachment = if_abap_behv=>mk-on
                      %control-mimetype = if_abap_behv=>mk-on
                      %control-filename = if_abap_behv=>mk-on
                      %control-longString = if_abap_behv=>mk-on
                      %control-FileNO = if_abap_behv=>mk-on
                      ).

    APPEND ls_file TO lt_file.
    MODIFY ENTITIES OF zchi_file
       ENTITY file
       CREATE FROM lt_file
       MAPPED DATA(mapped3).

  ENDMETHOD.


  METHOD to_text_app.
  ENDMETHOD.

  METHOD to_app2.

    DATA: ls_sample_text TYPE STRUCTURE FOR CREATE zchi_sd_sample,
          lt_sample_text TYPE TABLE FOR CREATE zchi_sd_sample.
    DATA: l_cid LIKE ls_sample_text-%cid.

    SELECT *
      FROM I_SalesDocument AS h
     INNER JOIN I_SalesDocumentItem AS i ON h~SalesDocument = i~SalesDocument
      INTO TABLE @DATA(lt_sd).

    DATA: lo_uuid TYPE REF TO if_system_uuid,
          l_uuid  TYPE sysuuid_x16.

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd2>).
      lo_uuid = cl_uuid_factory=>create_system_uuid(  ).
      l_uuid = lo_uuid->create_uuid_x16(  ).
      l_cid = l_cid + 1 .
*      ls_sample_text-longstring =  <ls_sd2>-salesdocument && ' /t ' && <ls_sd2>-salesdocument .
      TRY.
          DATA(xstring) = cl_abap_conv_codepage=>create_out( )->convert(
          <ls_sd2>-h-SalesDocument
          && | \t | && <ls_sd2>-h-salesgroup
          && | \t | && <ls_sd2>-h-salesdocumentdate
          && | \t | && <ls_sd2>-h-salesorganization
          && | \t | && <ls_sd2>-h-distributionchannel
          && | \t | && <ls_sd2>-h-organizationdivision
          && | \t | && <ls_sd2>-h-transactioncurrency
          && | \t | && <ls_sd2>-i-salesdocumentitem
          && | \t | && <ls_sd2>-i-material ).
        CATCH cx_sy_conversion_codepage INTO DATA(ex).
      ENDTRY.

      ls_sample_text = VALUE #(
                          %cid = l_cid
                          salesdocument = <ls_sd2>-h-salesdocument
                          salesgroup = <ls_sd2>-h-salesgroup
                          salesdocumentitem = <ls_sd2>-i-SalesDocumentItem
                          material         = <ls_sd2>-i-material
                          salesdocumentdate  = <ls_sd2>-h-salesdocumentdate
                          salesorganization   = <ls_sd2>-h-salesorganization
                          distributionchannel = <ls_sd2>-h-distributionchannel
                          organizationdivision = <ls_sd2>-h-organizationdivision
                          transactioncurrency  = <ls_sd2>-h-transactioncurrency
                          %control = VALUE #(
                                       salesdocument = cl_abap_behv=>flag_changed
                                       salesgroup = cl_abap_behv=>flag_changed
                                       salesdocumentitem = cl_abap_behv=>flag_changed
                                       material         = cl_abap_behv=>flag_changed
                                       salesdocumentdate  = cl_abap_behv=>flag_changed
                                       salesorganization   = cl_abap_behv=>flag_changed
                                       distributionchannel = cl_abap_behv=>flag_changed
                                       organizationdivision = cl_abap_behv=>flag_changed
                                       transactioncurrency  = cl_abap_behv=>flag_changed
                                        ) ).
      APPEND ls_sample_text TO lt_sample_text.

    ENDLOOP.

    MODIFY ENTITIES OF zchi_sd_sample IN LOCAL MODE
     ENTITY sample
     CREATE FROM lt_sample_text
     MAPPED DATA(mapped1).

  ENDMETHOD.

  METHOD file_name.

    DATA var TYPE string.
    DATA descript2 TYPE string.
    DATA l_filename TYPE string.
    DATA l_cid TYPE String.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.

    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF zchi_sd_sample  IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_sd).

    l_filename = keys[ 1 ]-%param-filename && '.txt'.

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd>).
*      l_cid = l_cid + 1.
      IF descript2 IS INITIAL.

        descript2 =  |SalesDocument \t salesgroup  \t salesdocumentdate \t |
          && | salesorganization \t distributionchannel \t organizationdivision \t|
          && | transactioncurrency \t salesdocumentitem \t material \n|
          && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.

      ELSE.
        descript2 = descript2 && |\n| && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.
      ENDIF.

    ENDLOOP.

    TRY.
        DATA(xstring3) = cl_abap_conv_codepage=>create_out( )->convert( descript2 ).
      CATCH cx_sy_conversion_codepage INTO DATA(ex3).
    ENDTRY.


    ls_file = VALUE #( %cid = '1'
                      FileNO = l_count
                      Attachment = xstring3
                      mimetype = 'text/plain'
                      Filename = l_filename
                      longString = descript2
                      %control-Attachment = if_abap_behv=>mk-on
                      %control-mimetype = if_abap_behv=>mk-on
                      %control-filename = if_abap_behv=>mk-on
                      %control-longString = if_abap_behv=>mk-on
                      %control-FileNO = if_abap_behv=>mk-on
                      ).

    APPEND ls_file TO lt_file.
    MODIFY ENTITIES OF zchi_file
       ENTITY file
       CREATE FROM lt_file
       MAPPED DATA(mapped3).
  ENDMETHOD.

  METHOD file_name2.

    DATA var TYPE string.
    DATA descript2 TYPE string.
    DATA l_filename TYPE string.
    DATA l_cid TYPE String.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.

    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF zchi_sd_sample  IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_sd).

    l_filename = keys[ 1 ]-%param-filename && '.txt'.

    LOOP AT lt_sd ASSIGNING FIELD-SYMBOL(<ls_sd>).
*      l_cid = l_cid + 1.
      IF descript2 IS INITIAL.

        descript2 =  |SalesDocument \t salesgroup  \t salesdocumentdate \t |
          && | salesorganization \t distributionchannel \t organizationdivision \t|
          && | transactioncurrency \t salesdocumentitem \t material \n|
          && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.

      ELSE.
        descript2 = descript2 && |\n| && <ls_sd>-SalesDocument
          && | \t | && <ls_sd>-salesgroup
          && | \t | && <ls_sd>-salesdocumentdate
          && | \t | && <ls_sd>-salesorganization
          && | \t | && <ls_sd>-distributionchannel
          && | \t | && <ls_sd>-organizationdivision
          && | \t | && <ls_sd>-transactioncurrency
          && | \t | && <ls_sd>-salesdocumentitem
          && | \t | && <ls_sd>-material.
      ENDIF.

    ENDLOOP.

    TRY.
        DATA(xstring3) = cl_abap_conv_codepage=>create_out( )->convert( descript2 ).
      CATCH cx_sy_conversion_codepage INTO DATA(ex3).
    ENDTRY.


    ls_file = VALUE #( %cid = '1'
                      FileNO = l_count
                      Attachment = xstring3
                      mimetype = 'text/plain'
*                      filename = 'text.txt'
                      Filename = l_filename
                      longString = descript2
                      %control-Attachment = if_abap_behv=>mk-on
                      %control-mimetype = if_abap_behv=>mk-on
                      %control-filename = if_abap_behv=>mk-on
                      %control-longString = if_abap_behv=>mk-on
                      %control-FileNO = if_abap_behv=>mk-on
                      ).

    APPEND ls_file TO lt_file.
    MODIFY ENTITIES OF zchi_file
       ENTITY file
       CREATE FROM lt_file
       MAPPED DATA(mapped3).
  ENDMETHOD.

  METHOD save_excel.

    DATA l_uuid TYPE string.
    "生成一個Excel 空檔
    DATA(lo_write_access) = xco_cp_xlsx=>document->empty( )->write_access( ).
    "建立Excel 頁籤
    DATA(lo_worksheet) = lo_write_access->get_workbook(
      )->worksheet->at_position( 1 ).

    DATA l_tabix TYPE i.
    DATA: l_column TYPE i.
    DATA: lw_tab_ref        TYPE REF TO data.
    DATA: lo_tablestructure TYPE REF TO cl_abap_structdescr.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.
    DATA: l_msg TYPE string.
    "檔案名
    DATA l_filename TYPE string.
    DATA: lv_json   TYPE /ui2/cl_json=>json.

    DATA: BEGIN OF ls_table,
            salesdocument        TYPE zch_sd_sample-salesdocument,
            salesdocumentitem    TYPE zch_sd_sample-salesdocumentitem,
            salesgroup           TYPE zch_sd_sample-salesgroup,
            material             TYPE zch_sd_sample-material,
            salesdocumentdate    TYPE zch_sd_sample-salesdocumentdate,
            salesorganization    TYPE zch_sd_sample-salesorganization,
            distributionchannel  TYPE zch_sd_sample-distributionchannel,
            organizationdivision TYPE zch_sd_sample-organizationdivision,
            transactioncurrency  TYPE zch_sd_sample-transactioncurrency,
          END OF ls_table.
    DATA lt_table LIKE TABLE OF ls_table.
*    DATA(lv_file_content) = lo_write_access->get_file_content( ).

    " A selection pattern that was obtained via XCO_CP_XLSX_SELECTION=>PATTERN_BUILDER.
    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    "計算當前筆數 用於排列序號
    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).
    IF l_count IS INITIAL.
      l_count = 1.

    ELSE.
      l_count += 1.

    ENDIF.

    "讀取所選的欄位資料
    READ ENTITIES OF zchi_sd_sample IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    CREATE DATA lw_tab_ref LIKE LINE OF lt_table.

    MOVE-CORRESPONDING lt_result to lt_table.

    "建立格式
    lo_worksheet->select( lo_selection_pattern
      )->row_stream(
      )->operation->write_from( REF #( lt_table )
      )->execute( ).

    "將lw_tab_ref 描述寫入 lo_tablestructure 為了得到欄位name
    lo_tablestructure ?= cl_abap_typedescr=>describe_by_data_ref( lw_tab_ref ).

    "宣告開始寫入位置
    DATA(lo_cursor) = lo_worksheet->cursor(
         io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
         io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
        ).

    "寫入 Field Name
    LOOP AT  lo_tablestructure->components ASSIGNING FIELD-SYMBOL(<ls_tab>) .

      IF sy-tabix = 1.
        lo_cursor->get_cell( )->value->write_from( <ls_tab>-name ).

      ELSE.
        lo_cursor->move_right( )->get_cell( )->value->write_from( <ls_tab>-name ).

      ENDIF.

    ENDLOOP.

    "寫入 Field Value
    LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<ls_result2>).

      l_tabix = sy-tabix + 1.

      CLEAR l_column.

      DATA(lo_cursor2) = lo_worksheet->cursor(
        io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
        io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( l_tabix )
      ).
      "讀取structure 欄位value 謝入對應的Field Name
      LOOP AT lo_tablestructure->components REFERENCE INTO DATA(lo_component).

        l_column = l_column + 1.

        ASSIGN COMPONENT lo_component->name OF STRUCTURE <ls_result2> TO FIELD-SYMBOL(<lfs_value>).

        IF sy-subrc = 0.
          IF l_column = 1.
            lo_cursor2->get_cell( )->value->write_from( <lfs_value> ).
          ELSE.
            lo_cursor2->move_right( )->get_cell( )->value->write_from( <lfs_value> ).
          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    lv_json = /ui2/cl_json=>serialize( data          = lt_table
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).
    IF keys[ 1 ]-%param-filename IS INITIAL.
      l_msg = '請輸入檔案名稱'.
      INSERT VALUE #(
       %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-warning
                                     text     = l_msg )
  ) INTO TABLE reported-sample.
    ELSE.

      l_filename = keys[ 1 ]-%param-filename && '.xlsx'.

      ls_file = VALUE #( %cid = '3'
                        FileNO = l_count
                        Attachment = lo_write_access->get_file_content( )
                        mimetype = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                        filename = l_filename
                        longString = lv_json
                        %control-Attachment = if_abap_behv=>mk-on
                        %control-mimetype = if_abap_behv=>mk-on
                        %control-filename = if_abap_behv=>mk-on
                        %control-longString = if_abap_behv=>mk-on
                        %control-FileNO = if_abap_behv=>mk-on
                        ).

      APPEND ls_file TO lt_file.

      MODIFY ENTITIES OF zchi_file
         ENTITY file
         CREATE FROM lt_file
         MAPPED DATA(mapped3)
         FAILED DATA(Failed1)
         REPORTED DATA(report3).

      LOOP AT mapped3-file ASSIGNING FIELD-SYMBOL(<ls_map>).
        DATA(lv_result) = <ls_map>-ruuid.
      ENDLOOP.

      l_uuid = lv_result.

      IF failed IS INITIAL.
        l_filename = l_filename && ' 建立成功'.
        l_msg = 'FileＮＯ : ' && l_count  && |\n 檔案: | && l_filename && |\n UUID: | && l_uuid .
        INSERT VALUE #(
         %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-success
                                       text     = l_msg )
    ) INTO TABLE reported-sample.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD save_json.

    DATA l_uuid TYPE string .
    DATA: descript TYPE string,
          l_msg    TYPE string.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.
    DATA l_filename TYPE string.
    DATA:
      lrf_descr TYPE REF TO cl_abap_typedescr,
      lv_json   TYPE /ui2/cl_json=>json.

    DATA: BEGIN OF ls_table,
            salesdocument        TYPE zch_sd_sample-salesdocument,
            salesdocumentitem    TYPE zch_sd_sample-salesdocumentitem,
            salesgroup           TYPE zch_sd_sample-salesgroup,
            material             TYPE zch_sd_sample-material,
            salesdocumentdate    TYPE zch_sd_sample-salesdocumentdate,
            salesorganization    TYPE zch_sd_sample-salesorganization,
            distributionchannel  TYPE zch_sd_sample-distributionchannel,
            organizationdivision TYPE zch_sd_sample-organizationdivision,
            transactioncurrency  TYPE zch_sd_sample-transactioncurrency,
          END OF ls_table.
    DATA lt_table LIKE TABLE OF ls_table.

    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF zchi_sd_sample IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    MOVE-CORRESPONDING lt_result to lt_table.

    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    lv_json = /ui2/cl_json=>serialize( data          = lt_table
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).


    LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<ls_result>).
      IF descript IS INITIAL.

        descript =  |SalesDocument \t salesgroup \t salesdocumentdate \t |
          && | salesorganization \t distributionchannel \t organizationdivision \t|
          && | transactioncurrency \t salesdocumentitem \t material \n|
          && <ls_result>-SalesDocument
          && | \t | && <ls_result>-salesgroup
          && | \t | && <ls_result>-salesdocumentdate
          && | \t | && <ls_result>-salesorganization
          && | \t | && <ls_result>-distributionchannel
          && | \t | && <ls_result>-organizationdivision
          && | \t | && <ls_result>-transactioncurrency
          && | \t | && <ls_result>-salesdocumentitem
          && | \t | && <ls_result>-material.

      ELSE.
        descript = descript
          && |\n| && <ls_result>-SalesDocument
          && | \t | && <ls_result>-salesgroup
          && | \t | && <ls_result>-salesdocumentdate
          && | \t | && <ls_result>-salesorganization
          && | \t | && <ls_result>-distributionchannel
          && | \t | && <ls_result>-organizationdivision
          && | \t | && <ls_result>-transactioncurrency
          && | \t | && <ls_result>-salesdocumentitem
          && | \t | && <ls_result>-material.
      ENDIF.
    ENDLOOP.

    TRY.
        DATA(xstring) = cl_abap_conv_codepage=>create_out( )->convert( lv_json ).
      CATCH cx_sy_conversion_codepage INTO DATA(ex).
    ENDTRY.

    IF keys[ 1 ]-%param-filename IS INITIAL.
      l_msg = '請輸入檔案名稱'.
      INSERT VALUE #(
       %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-warning
                                     text     = l_msg )
  ) INTO TABLE reported-sample.
    ELSE.
      l_filename = keys[ 1 ]-%param-filename && '.json'.


      ls_file = VALUE #( %cid = '1'
                        FileNO = l_count
                        Attachment = xstring
                        mimetype = 'application/json'
                        filename = l_filename
                        longString = lv_json
                        %control-Attachment = if_abap_behv=>mk-on
                        %control-mimetype = if_abap_behv=>mk-on
                        %control-filename = if_abap_behv=>mk-on
                        %control-longString = if_abap_behv=>mk-on
                        %control-FileNO = if_abap_behv=>mk-on
                        ).

      APPEND ls_file TO lt_file.

      MODIFY ENTITIES OF zchi_file
         ENTITY file
         CREATE FROM lt_file
         MAPPED DATA(mapped3)
         FAILED DATA(Failed1).



      LOOP AT mapped3-file ASSIGNING FIELD-SYMBOL(<ls_map>).
        DATA(lv_result) = <ls_map>-ruuid.
      ENDLOOP.

      l_uuid = lv_result.

      IF failed IS INITIAL.
        l_filename = l_filename && ' 建立成功'.
        l_msg = 'FileＮＯ : ' && l_count  && |\n 檔案: | && l_filename && |\n UUID: | && l_uuid .
        INSERT VALUE #(
         %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-success
                                       text     = l_msg )
    ) INTO TABLE reported-sample.
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD save_text.

    DATA l_uuid TYPE string .
    DATA: descript TYPE string,
          l_msg    TYPE string.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.
    DATA l_filename TYPE string.
    DATA l_tabix TYPE i.
    DATA: l_column TYPE i.
    DATA: lw_tab_ref        TYPE REF TO data.
    DATA: lo_tablestructure TYPE REF TO cl_abap_structdescr.

    DATA: BEGIN OF ls_table,
            salesdocument        TYPE zch_sd_sample-salesdocument,
            salesdocumentitem    TYPE zch_sd_sample-salesdocumentitem,
            salesgroup           TYPE zch_sd_sample-salesgroup,
            material             TYPE zch_sd_sample-material,
            salesdocumentdate    TYPE zch_sd_sample-salesdocumentdate,
            salesorganization    TYPE zch_sd_sample-salesorganization,
            distributionchannel  TYPE zch_sd_sample-distributionchannel,
            organizationdivision TYPE zch_sd_sample-organizationdivision,
            transactioncurrency  TYPE zch_sd_sample-transactioncurrency,
          END OF ls_table.
    DATA lt_table LIKE TABLE OF ls_table.


    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF  zchi_sd_sample IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    CREATE DATA lw_tab_ref LIKE LINE OF lt_table.

    MOVE-CORRESPONDING lt_result to lt_table.

    "將lw_tab_ref 描述寫入 lo_tablestructure 為了得到欄位name
    lo_tablestructure ?= cl_abap_typedescr=>describe_by_data_ref( lw_tab_ref ).

    "寫入 Field Value
    LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<ls_result2>).

      IF sy-tabix = 1.
        "寫入 Field Name
        LOOP AT  lo_tablestructure->components ASSIGNING FIELD-SYMBOL(<ls_tab>) .

          IF sy-tabix = 1.
            descript = <ls_tab>-name.
          ELSE.
            descript = descript &&  | \t | &&  <ls_tab>-name.
          ENDIF.

          AT LAST.
            descript = descript && | \n |.
          ENDAT.

        ENDLOOP.
      ENDIF.

      CLEAR l_column.

      "讀取structure 欄位value 謝入對應的Field Name
      LOOP AT lo_tablestructure->components REFERENCE INTO DATA(lo_component).

        l_column = l_column + 1.

        ASSIGN COMPONENT lo_component->name OF STRUCTURE <ls_result2> TO FIELD-SYMBOL(<lfs_value>).

        IF sy-subrc = 0.
          IF l_column = 1.
            descript = descript && <lfs_value>.
          ELSE.
            descript = descript &&  | \t | && <lfs_value>.
          ENDIF.

        ENDIF.

        AT LAST.
          descript = descript && | \n |.
        ENDAT.
      ENDLOOP.

    ENDLOOP.

    TRY.
        DATA(xstring) = cl_abap_conv_codepage=>create_out( )->convert( descript ).
      CATCH cx_sy_conversion_codepage INTO DATA(ex).
    ENDTRY.

    IF keys[ 1 ]-%param-filename IS INITIAL.
      l_msg = '請輸入檔案名稱'.
      INSERT VALUE #(
       %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-warning
                                     text     = l_msg )
  ) INTO TABLE reported-sample.
    ELSE.

      l_filename = keys[ 1 ]-%param-filename && '.text'.

      ls_file = VALUE #( %cid = '1'
                        FileNO = l_count
                        Attachment = xstring
                        mimetype = 'text/plain'
                        filename = l_filename
                        longString = descript
                        %control-Attachment = if_abap_behv=>mk-on
                        %control-mimetype = if_abap_behv=>mk-on
                        %control-filename = if_abap_behv=>mk-on
                        %control-longString = if_abap_behv=>mk-on
                        %control-FileNO = if_abap_behv=>mk-on
                        ).

      APPEND ls_file TO lt_file.

      "用tab 分割 寫入xls 開啟檔案會有錯誤問題 但可以正常顯示成excel檔(舊版Excel)
*    l_filename = keys[ 1 ]-%param-filename && '.xls'.
*
*    ls_file = VALUE #( %cid = '2'
*                      FileNO = l_count
*                      Attachment = xstring
*                      mimetype = 'application/vnd.ms-excel'
*                      filename = l_filename
*                      longString = descript
*                      %control-Attachment = if_abap_behv=>mk-on
*                      %control-mimetype = if_abap_behv=>mk-on
*                      %control-filename = if_abap_behv=>mk-on
*                      %control-longString = if_abap_behv=>mk-on
*                      %control-FileNO = if_abap_behv=>mk-on
*                      ).
*
*    APPEND ls_file TO lt_file.

      MODIFY ENTITIES OF zchi_file
         ENTITY file
         CREATE FROM lt_file
         MAPPED DATA(mapped3)
         FAILED DATA(failed3)
         REPORTED DATA(report).


      READ ENTITIES OF zchi_file
          ENTITY file
          ALL FIELDS WITH VALUE #( ( ruuid = mapped3-file[ 1 ]-ruuid ) )
          RESULT FINAL(read_entity)
          FAILED FINAL(read_failed).

      LOOP AT mapped3-file ASSIGNING FIELD-SYMBOL(<ls_map>).
        DATA(lv_result) = <ls_map>-ruuid.
      ENDLOOP.

      l_uuid = lv_result.

      IF failed IS INITIAL.
        l_filename = l_filename && ' 建立成功'.
        l_msg = 'FileＮＯ : ' && l_count  && |\n 檔案: | && l_filename && |\n UUID: | && l_uuid .
        INSERT VALUE #(
         %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-success
                                       text     = l_msg )
    ) INTO TABLE reported-sample.
      ENDIF.

    ENDIF.


  ENDMETHOD.

  METHOD save_xml.

    DATA l_uuid TYPE string .
    DATA: descript TYPE string,
          l_msg    TYPE String.
    DATA: ls_file TYPE STRUCTURE FOR CREATE zchi_file,
          lt_file TYPE TABLE FOR CREATE zchi_file.
    DATA l_filename TYPE string.
    DATA: lv_json   TYPE /ui2/cl_json=>json.
    "不同format XML
*    DATA: SalesDocument     TYPE xsduuid_char,
*          salesgroup        TYPE xsduuid_char,
*          salesdocumentdate TYPE xsduuid_char,
*          exc_trafo         TYPE REF TO cx_transformation_error,
*          exc_prev          TYPE REF TO cx_root.
    DATA l_tabix TYPE i.
    DATA: l_column TYPE i.
    DATA: lw_tab_ref        TYPE REF TO data.
    DATA: lo_tablestructure TYPE REF TO cl_abap_structdescr.

    DATA: BEGIN OF ls_table,
            salesdocument        TYPE zch_sd_sample-salesdocument,
            salesdocumentitem    TYPE zch_sd_sample-salesdocumentitem,
            salesgroup           TYPE zch_sd_sample-salesgroup,
            material             TYPE zch_sd_sample-material,
            salesdocumentdate    TYPE zch_sd_sample-salesdocumentdate,
            salesorganization    TYPE zch_sd_sample-salesorganization,
            distributionchannel  TYPE zch_sd_sample-distributionchannel,
            organizationdivision TYPE zch_sd_sample-organizationdivision,
            transactioncurrency  TYPE zch_sd_sample-transactioncurrency,
          END OF ls_table.
    DATA lt_table LIKE TABLE OF ls_table.

    SELECT COUNT( * )
    FROM zcht_file INTO @DATA(l_count).

    IF l_count IS INITIAL.
      l_count = 1.
    ELSE.
      l_count += 1.
    ENDIF.

    READ ENTITIES OF zchi_sd_sample IN LOCAL MODE
    ENTITY sample
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    CREATE DATA lw_tab_ref LIKE LINE OF lt_table.

    MOVE-CORRESPONDING lt_result to lt_table.

    "將lw_tab_ref 描述寫入 lo_tablestructure 為了得到欄位name
    lo_tablestructure ?= cl_abap_typedescr=>describe_by_data_ref( lw_tab_ref ).

    "不同format XML
*    CALL TRANSFORMATION id SOURCE SalesDocument = <ls_result>-SalesDocument
*                                  salesgroup = <ls_result>-salesgroup
*                                  salesdocumentdate = <ls_result>-salesdocumentdate
*                              result XML FINAL(xml_xstring).

*    DATA(reader) = cl_sxml_string_reader=>create(
*                     cl_abap_conv_codepage=>create_out(
*                       )->convert( descript ) ).
*    DATA(writer) = cl_sxml_string_writer=>create(
*                     type = if_sxml=>co_xt_xml10 ).
*
*    TRY.
*        reader->next_node( ).
*        reader->skip_node( writer ).
*      CATCH cx_sxml_parse_error INTO DATA(error).
*    ENDTRY.
    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    "json格式for descript
    lv_json = /ui2/cl_json=>serialize( data          = lt_table
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).

    LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<ls_result>).

      IF descript IS INITIAL.

        descript =  |SalesDocument \t salesgroup \t salesdocumentdate \t |
          && | salesorganization \t distributionchannel \t organizationdivision \t|
          && | transactioncurrency \t salesdocumentitem \t material \n|
          && <ls_result>-SalesDocument
          && | \t | && <ls_result>-salesgroup
          && | \t | && <ls_result>-salesdocumentdate
          && | \t | && <ls_result>-salesorganization
          && | \t | && <ls_result>-distributionchannel
          && | \t | && <ls_result>-organizationdivision
          && | \t | && <ls_result>-transactioncurrency
          && | \t | && <ls_result>-salesdocumentitem
          && | \t | && <ls_result>-material.
      ELSE.
        descript = descript
          && |\n| && <ls_result>-SalesDocument
          && | \t | && <ls_result>-salesgroup
          && | \t | && <ls_result>-salesdocumentdate
          && | \t | && <ls_result>-salesorganization
          && | \t | && <ls_result>-distributionchannel
          && | \t | && <ls_result>-organizationdivision
          && | \t | && <ls_result>-transactioncurrency
          && | \t | && <ls_result>-salesdocumentitem
          && | \t | && <ls_result>-material.
      ENDIF.

    ENDLOOP.

    CALL TRANSFORMATION id SOURCE lt_result = lt_table
                           RESULT XML FINAL(xml_xstring).

    DATA(ls_01) = cl_sxml_string_reader=>create( xml_xstring ).
    DATA(writer) = cl_sxml_string_writer=>create(
                     type = if_sxml=>co_xt_json ).

    IF keys[ 1 ]-%param-filename IS INITIAL.
      l_msg = '請輸入檔案名稱'.
      INSERT VALUE #(
       %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-warning
                                     text     = l_msg )
  ) INTO TABLE reported-sample.
    ELSE.

      l_filename = keys[ 1 ]-%param-filename && '.xml'.

      ls_file = VALUE #( %cid = '2'
                        FileNO = l_count
                        Attachment = xml_xstring
                        mimetype = 'text/xml'
                        filename = l_filename
                        longString = xml_xstring
                        %control-Attachment = if_abap_behv=>mk-on
                        %control-mimetype = if_abap_behv=>mk-on
                        %control-filename = if_abap_behv=>mk-on
                        %control-longString = if_abap_behv=>mk-on
                        %control-FileNO = if_abap_behv=>mk-on
                        ).

      APPEND ls_file TO lt_file.

      MODIFY ENTITIES OF zchi_file
          ENTITY file
          CREATE FROM lt_file
          MAPPED DATA(mapped3)
          FAILED DATA(Failed1).



      LOOP AT mapped3-file ASSIGNING FIELD-SYMBOL(<ls_map>).
        DATA(lv_result) = <ls_map>-ruuid.
      ENDLOOP.

      l_uuid = lv_result.

      IF failed IS INITIAL.
        l_filename = l_filename && ' 建立成功'.
        l_msg = 'FileＮＯ : ' && l_count  && |\n 檔案: | && l_filename && |\n UUID: | && l_uuid .
        INSERT VALUE #(
         %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-success
                                       text     = l_msg )
    ) INTO TABLE reported-sample.
      ENDIF.

    ENDIF.
      TRY.
          DATA(lo_mail2) = cl_bcs_mail_message=>create_instance(  ).
          lo_mail2->set_sender( 'DoNotReply@my405649.mail.s4hana.cloud.sap' ).  "可以寄到內/外部

          lo_mail2->add_recipient( 'chase80090123@gmail.com' ).
*      lo_mail->add_recipient( 'kevinlee7755@gmail.com' ).
*      lo_mail->add_recipient( 'chasechou@soetek.com.tw' ).

          lo_mail2->set_subject( |Test Email from S4HC| ).
          lo_mail2->set_main( cl_bcs_mail_textpart=>create_instance(
            iv_content = |<h1>Test1023</h1><p>This is a test mail in HTML format.</p><br>Hi</br>|
            iv_content_type = 'text/html' ) ).
          lo_mail2->add_attachment( cl_bcs_mail_textpart=>create_instance(
             iv_content      = '<note><to>John</to><from>Jane</from><body>My nice XML!</body></note>'
             iv_content_type = 'text/xml'
             iv_filename     = 'Text_Attachment.xml'
             ) ).
*      cl_abap_tx=>save(  ).
*      lo_mail2->send_async(  ).


        CATCH cx_bcs_mail INTO DATA(lx_mail).

      ENDTRY.
  ENDMETHOD.

ENDCLASS.

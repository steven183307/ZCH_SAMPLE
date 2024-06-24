@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View for TXT'
@UI: {
  headerInfo: {
    typeName: 'text',
    typeNamePlural: 'text'
  }
}
define root view entity zchc_sd_sample
//  provider contract transactional_query
  as projection on zchi_sd_sample

{
      @UI.facet: [
        {
                    label: 'Header Info',
                    id: 'HeaderInfo',
                    type: #COLLECTION,
                    position: 10
        },
      {
      id: 'text',
      type: #IDENTIFICATION_REFERENCE,
      label: 'text',
      parentId: 'HeaderInfo',
      targetQualifier: 'text'
      } ]
      
      

      @UI: {lineItem: [ 
//                      { type: #FOR_ACTION, dataAction: 'create_text', label: 'create_text'},
                                            { type: #FOR_ACTION, dataAction: 'save', label: 'ADD SO Data'},
                      
//                       ,{type: #FOR_INTENT_BASED_NAVIGATION, semanticObjectAction: 'display', label: 'to_text_app'}
                     { type: #FOR_ACTION, dataAction: 'to_app2', label: 'to_app2'},
//                      ,{ type: #FOR_INTENT_BASED_NAVIGATION , semanticObjectAction: 'to_text_app'}
                     { type: #FOR_ACTION, dataAction: 'save_text', label: 'Create Text', invocationGrouping: #CHANGE_SET},
                     { type: #FOR_ACTION, dataAction: 'save_json', label: 'Create Json', invocationGrouping: #CHANGE_SET},
                     { type: #FOR_ACTION, dataAction: 'save_xml', label: 'Create Xml', invocationGrouping: #CHANGE_SET},
                     { type: #FOR_ACTION, dataAction: 'save_excel', label: 'Create Excel', invocationGrouping: #CHANGE_SET}]

                    
      }
//      @UI.hidden: true
  key ruuid,
//      
      @UI: {
      selectionField: [{ position: 10 }],
      lineItem: [ { position: 10 }]
      }
      @UI.identification: [ {
        position: 10 ,
        label: 'salesdocument',
        qualifier: 'text' } ]
  key salesdocument,
      @UI: {
      lineItem: [ { position: 30} ]
      }
      @UI.identification: [ {
        position: 30 ,
        label: 'salesgroup',
        qualifier: 'text'
      } ]
      salesgroup,
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [ { position: 20 ,
                        importance: #MEDIUM,
                        label: 'salesdocumentitem'
                     } ]
      @UI.identification: [ {
        position: 20 ,
        label: 'salesdocumentitem',
        qualifier: 'text'
      } ]
      salesdocumentitem ,

      @UI.lineItem: [ {
      position: 30 ,
      importance: #MEDIUM,
      label: 'material'
      } ]
      @UI.identification: [ {
        position: 30 ,
        label: 'material',
        qualifier: 'text'
      } ]
      material,
      @UI.lineItem: [ {
      position: 40 ,
      importance: #MEDIUM,
      label: 'salesdocumentdate'
      } ]
      @UI.identification: [ {
        position: 40 ,
        label: 'salesdocumentdate',
        qualifier: 'text'
      } ]
      salesdocumentdate,
      @UI.identification: [ {
      position: 50 ,
      label: 'salesorganization',
      qualifier: 'text'
      } ]
      @UI.lineItem: [ {
      position: 50,
      label: 'salesorganization'
      } ]
      salesorganization,
            @UI.lineItem: [ {
      position: 60 ,
      importance: #MEDIUM,
      label: 'distributionchannel'
      } ]
      @UI.identification: [ {
        position: 60 ,
        label: 'distributionchannel',
        qualifier: 'text'
      } ]
      distributionchannel,
      @UI.lineItem: [ {
      position: 70 ,
      importance: #MEDIUM,
      label: 'organizationdivision'
      } ]
      @UI.identification: [ {
        position: 70 ,
        label: 'organizationdivision',
        qualifier: 'text'
      } ]
      organizationdivision,
      @UI.identification: [ {
      position: 80 ,
      label: 'transactioncurrency',
      qualifier: 'text'
      } ]
      @UI.lineItem: [ {
      position: 80,
      label: 'transactioncurrency'
      } ]
      transactioncurrency,
      //connect to another app  need to see  business role > space app semanticObject & Action
      @Consumption.semanticObject: 'ZCH_FILE01'
      @UI: {lineItem: [ 
            {type: #FOR_INTENT_BASED_NAVIGATION, semanticObjectAction: 'display', label: 'to_File_app'}
      ] }
      locallastchangedat

      
}

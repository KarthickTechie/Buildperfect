## BuildPerfect

## Getting Started

## Appbuilder - SplitPanel

Drag drop widgets [BPWidgets] from left panel to center panel [ItemsPanel].
the array of formcontrol knows as [List<BPWidgets>]

BPWidgetsList contains all the dragged BPWidgets , you can get it from [SplitPanel] {upper} property

## BpwidgetBloc

BpwidgetBloc manages very important event and state handler.
This contains the necessary event handler that updates the
bpwidgetprops
bpwidgetevents
bpwidgetdatasource properties

## Configure Formcontrol properties

click on the dragged BPWiget to configure formcontrol properties [BpwidgetProps]
BpWidgetProps are configured in [RightPanel] [PropsPanel] widget

## Actions

actions are associated to button at inital level , in future it can be scaled to all formcontrol

# Usecase 1 - PageNavigation action onClick Button

since action is a dynamic function

if user click on the button formcontrol on page1, then the navigation should happen to page2
page1 ---> page2
Action is a composition of tasks

## Task1 - Navigation

button onclick - go -> will go to next page url

button onclick - gowithdata -> will got to next page with data as query param
button onclick - saveandgo -> will save the current formdata to server show success or failure
message in alert dialog and go to next page

Each task will have SUBTASK - example task go is a task , it's subtask is empty array

# Task - go - subtask is seturl and push

{
"widget":<BPWidget>{
"props":<BPWidgetProps>{
"id":"",
"label:"",
},
"action": <BpWidgetAction>{
"actionId" : "uniqueActionId",
"job": <BpWidgetJob>{
"jobType":"Navigation",
"jobId" : "Navigation_uniquetaskid"
"jobName": "go"
"jobData":<NavigationtaskDataprovider>{
"url":"pageurl",
"data":Map<String,dynamic>{}
},
"tasks" : <Navigationtask>[
{
"taskId":"",
"taskName":"checkUrl",
"status":"success | error"
},
{
"taskId":"",
"taskName":"navigation",
"status":"success | error"
}
]
}
}
}
}

# Task - saveandgo

         subtask - checkFormName , checkFormStatus , checkVerificationField ,
                   verification , callFormSaveAPI

{
"action":{
"actionId" : "uniqueActionId"
"job" :{
"jobType":"SaveAndGoNavigation",
"jobId" : "SaveAndGoNavigation_uniquetaskid",
"jobName": "saveandgo",
"jobData":<SaveAndGoNavigationtaskParams>{
'submit_api_config':<API_CONFIG_PARAMS>{
'apitype':'submit',
'apiendpoint':'',
'apiname':'',
'api_request_map':{},
'api_response_map':{},
'api_success_config':<APISuccessConfig>{
'url':'pageurl',
'message':'success_message'
},
'api_error_config':<APIErrorConfig>{
'url':'pageurl',
'message':'success_message'
},

            },

            'data':Map<String,dynamic>{},
            'verification_api_config':<API_CONFIG_PARAMS>[
        {
            'api_type':'verification',
            'apiendpoint':'',
            'apiname':'',
            'api_request_map':{},
            'api_response_map':{},
            'api_success_config':<APISuccessConfig>{
                'url':'pageurl',
                'message':'success_message'
            },
            'api_error_config':<APIErrorConfig>{
                'url':'pageurl',
                'message':'success_message'
            },
        },
        {

            'apiendpoint':'',
            'apiname':'',
            'api_request_map':{},
            'api_response_map':{},
            'api_success_config':<APISuccessConfig>{
                'url':'pageurl',
                'message':'success_message'
            },
            'api_error_config':<APIErrorConfig>{
                'url':'pageurl',
                'message':'success_message'
            },
        }

            ]

        tasks : <SaveAndGoNavigationTask>[
            {
                taskId:"",
                taskName:"checkFormStatus",
                status:"success | error"
            },
            {
                taskId:"",
                taskName:"verifyFormFields",
                status:"success | error"
            },
            {
                taskId:"",
                taskName:"saveForm",
                status:"success | error"
            },
            {
                taskId:"",
                taskName:"navigation",
                status:"success | error"
            }


            ]
          }
        }
    }

}

/// BPRunTime

bool \_checkTheNavURL() {
var datafromappbuilder = BPDataProvider();
if(datafromappbuilder.data.url.isNotEmpty || urlLib.isAvailable(datafromappbuilder.data.url) ){

        return true

    }

}

Map<string , dynamic> bpruntimelib = {
'checkUrl' : \_checkTheNavURL
}

import ballerina/http;
import ballerinax/slack;
// import ballerina/io;

type SlackConfig record {
    string authToken;
    string channelName;
    
};

type Message record{
    string text;
};

type output record {
    string message;
};

configurable SlackConfig config = ?;

// Slack client configuration
slack:ConnectionConfig slackConfig = {
    auth: {
        token: config.authToken
    }
};

// Creating a Slack client
slack:Client slackClient = check new(slackConfig);

// A service representing a network-accessible API bound to port `9090`
service /slack\-api on new http:Listener(9090) {

    resource function post sendMessageToSlack(http:Caller caller,http:Request request) 
    returns error? {
       
        // var payload = check req.getBodyParts();
        
        map<string>|http:ClientError textmap = request.getFormParams();  

        string msg;

        if textmap is http:ClientError{
            return;
        }
        else{
            msg = <string>textmap["text"];
        }

        slack:Message message = {
            channelName: config.channelName,
            text: msg
        };

        string|error messageResponse = slackClient->postMessage(message);

        // io:print(text);
        

        // if (messageResponse is error) {
        //     output temp = { message: "Error" };
        //     return temp;
        // } else {
        //     output temp = { message: "Message delivery successfull" };
        //     return temp;
        // }
    }

    resource function get sample() returns string|error? {
        return "HI";
    }
}

//     resource function put updateSlackMessage(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to update a message in Slack
//         // Extract necessary data from the request payload and update the message

//         // For demonstration purposes, this code assumes the message details and timestamp are sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string text = check payload.text;
//         string timestamp = check payload.timestamp; // Message timestamp

//         slack:Message message = {
//             channelName: channel,
//             text: text,
//             timestamp: timestamp
//         };

//         string|error updateResponse = slackClient->updateMessage(message);

//         if (updateResponse is error) {
//             return { "error": updateResponse.reason() };
//         } else {
//             return { "message": "Message updated successfully" };
//         }
//     }

//     // Endpoint to delete a Slack message
//     @http:ResourceConfig {
//         methods: ["DELETE"],
//         path: "/delete-message"
//     }
//     resource function deleteSlackMessage(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to delete a message in Slack
//         // Extract necessary data from the request payload and delete the message

//         // For demonstration purposes, this code assumes the timestamp of the message to be deleted is sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string timestamp = check payload.timestamp; // Message timestamp

//         slack:Message message = {
//             channelName: channel,
//             timestamp: timestamp
//         };

//         string|error deleteResponse = slackClient->deleteMessage(message);

//         if (deleteResponse is error) {
//             return { "error": deleteResponse.reason() };
//         } else {
//             return { "message": "Message deleted successfully" };
//         }
//     }

//     // Endpoint to list Slack channels
//     @http:ResourceConfig {
//         methods: ["GET"],
//         path: "/list-channels"
//     }
//     resource function listSlackChannels(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to list channels in Slack

//         slack:ChannelListResponse|error channelsResponse = slackClient->listChannels();

//         if (channelsResponse is error) {
//             return { "error": channelsResponse.reason() };
//         } else {
//             return channelsResponse;
//         }
//     }

//     // Endpoint to upload a file to Slack
//     @http:ResourceConfig {
//         methods: ["POST"],
//         path: "/upload-file"
//     }
//     resource function uploadFileToSlack(http:Caller caller, http:Request req) returns json|error {
//         // Your implementation to upload a file to Slack
//         // Extract necessary data from the request payload and upload the file
        
//         // For demonstration purposes, this code assumes file details are sent in the request payload
//         var payload = check req.getJsonPayload();
//         string channel = check payload.channel;
//         string filePath = check payload.filePath;

//         slack:FileUploadResponse|error fileUploadResponse = slackClient->uploadFile(channel, filePath);

//         if (fileUploadResponse is error) {
//             return { "error": fileUploadResponse.reason() };
//         } else {
//             return fileUploadResponse;
//         }
//     }
// }

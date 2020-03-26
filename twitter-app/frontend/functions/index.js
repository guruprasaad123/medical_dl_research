
const functions = require('firebase-functions');

const nodemailer = require("nodemailer");
// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions


exports.feedbackMail =  functions.https.onCall((data, response) => {
  
   // const gmailEmail = functions.config().gmail.email;
    //const gmailPassword = functions.config().gmail.password;
const mailTransport = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true, // use SSL
    auth: {
         user:'ssi.annanagar2019@gmail.com',
         pass:'Saissi@123'
          }
});

const fullname =data.fullname,email =data.email,subject=data.subject,phoneno = data.phoneno,opinion = data.opinion ;

        var mail = {
        from: "ssi.annanagar2019@gmail.com",
        to: "ssi_annanagar@yahoo.com",
        subject: "SSI Computer Education [comments] ",
        text: "Node.js New Universe for me",
        html: `<!DOCTYPE html>
        <html>
        <head>
        <style>
        table {
          font-family: arial, sans-serif;
          border-collapse: collapse;
          width: 100%;
        }
        
        td, th {
          border: 1px solid #dddddd;
          text-align: left;
          padding: 8px;
        }
        
        tr:nth-child(even) {
          background-color: #dddddd;
        }
        </style>
        </head>
        <body>
        
        <h2>Comments detail.</h2>
        
        <table>
          <tr>
            <th>Name</th>
            <td> ${fullname} </td>
          
          </tr>
          <tr>
            <th>Email</th>
            <td> ${email} </td>
        
          </tr>
          <tr>
            <th>Subject</th>
            <td> ${subject} </td>
          
          </tr>
          <tr>
            <th>Phone No.</th>
            <td> ${ phoneno }</td>
            
          </tr>
            <tr>
            <th>Comments</th>
            <td> ${opinion}</td>
            
          </tr>
        
         
        </table>
        
        </body>
        </html>
        `
    };
    
    mailTransport.sendMail(mail, (error, response)=>{
        if(error){
            console.log('error => ',error);
        }else{
            console.log("Message sent: " + response.message);
        }
    
        mailTransport.close();
    });

    return functions.config().gmail;
});

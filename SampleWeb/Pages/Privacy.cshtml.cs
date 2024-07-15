using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using System.Text;
using RabbitMQ.Client;

namespace SampleWeb.Pages {
    public class PrivacyModel : PageModel {
        private readonly ILogger<PrivacyModel> _logger;

        [BindProperty]
        public string InputValue { get; set; }

        public PrivacyModel (ILogger<PrivacyModel> logger) {
            _logger = logger;
        }

        public void OnGet () {
        }

        public void OnPostMyButtonClicked()
        {
            // Your code here
            _logger.LogInformation("Button was clicked!");

            //var factory = new ConnectionFactory() { HostName = "localhost" };
            var factory = new ConnectionFactory() { HostName = "172.20.240.1" };
            var connection = factory.CreateConnection();
            var channel = connection.CreateModel();


            channel.QueueDeclare(queue: "hello",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);


            string message = InputValue;

            //string routingKey = inputField.Text; //Needs to be random??

            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "hello",
                                 basicProperties: null,
                                 body: body);

            //Response.Write($" [x] Sent {message}");

        }
    }
}

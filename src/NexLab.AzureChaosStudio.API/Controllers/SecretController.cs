using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.AspNetCore.Mvc;

namespace NexLab.AzureChaosStudio.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SecretController : ControllerBase
    {
        private readonly string _keyVaultUrl;
        private readonly string _secretName;

        public SecretController(IConfiguration configuration)
        {
            _keyVaultUrl = configuration.GetValue<string>("KeyVaultUrl") ??
                           throw new InvalidOperationException("Missing 'keyVaultUrl' configuration");
            _secretName = configuration.GetValue<string>("KeyVaultSecretName") ??
                          throw new InvalidOperationException("Missing 'KeyVaultSecretName' configuration");
        }

        [HttpGet(Name = "Get")]
        public IActionResult Get()
        {
            try
            {
                var client = new SecretClient(new Uri(_keyVaultUrl), new DefaultAzureCredential(), new SecretClientOptions());

                var secret = client.GetSecret(_secretName);

                return Ok(secret.Value.Value);
            }
            catch (Exception)
            {
                return StatusCode((StatusCodes.Status502BadGateway), "Getting KeyVault secret is denied");
            }
        }
    }
}

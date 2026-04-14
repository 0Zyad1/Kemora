using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Kemora.Application.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Threading.Tasks;

namespace Kemora.Infrastructure.Services
{
    public class CloudinaryImageService : IImageService
    {
        private readonly Cloudinary? _cloudinary;
        private readonly ILogger<CloudinaryImageService> _logger;

        public CloudinaryImageService(IConfiguration config, ILogger<CloudinaryImageService> logger)
        {
            _logger = logger;
            var cloudName = config["Cloudinary:CloudName"];
            var apiKey = config["Cloudinary:ApiKey"];
            var apiSecret = config["Cloudinary:ApiSecret"];

            if (string.IsNullOrWhiteSpace(cloudName) || string.IsNullOrWhiteSpace(apiKey) || string.IsNullOrWhiteSpace(apiSecret))
            {
                _logger.LogWarning("Cloudinary is not configured. Image uploads will be unavailable until Cloudinary settings are provided.");
                return;
            }

            var acc = new Account(cloudName, apiKey, apiSecret);
            _cloudinary = new Cloudinary(acc);
        }

        public async Task<string?> UploadImageAsync(Stream fileStream, string fileName)
        {
            if (_cloudinary == null)
            {
                return null;
            }

            if (fileStream.Length > 0)
            {
                var uploadParams = new ImageUploadParams
                {
                    File = new FileDescription(fileName, fileStream),
                    Transformation = new Transformation().Height(1000).Width(1000).Crop("limit")
                };
                
                var uploadResult = await _cloudinary.UploadAsync(uploadParams);
                return uploadResult.SecureUrl?.ToString();
            }

            return null;
        }
    }
}

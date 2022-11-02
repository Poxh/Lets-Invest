using lets_invest_api.Dto;
using lets_invest_api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace lets_invest_api.Controllers;

[Route("api/[controller]")]
    [ApiController]
    public class CryptoController : ControllerBase
    {
        private readonly Database database;

        public CryptoController(Database _database) {
            database = _database;    
        }

        [HttpGet]
        public async Task<ActionResult<ICollection<Crypto>>> GetCryptos([FromQuery] string DisplayName)
        {
            return Ok(await database.Cryptos.Where(p => p.Portfolio.User.DisplayName == DisplayName).ToListAsync());
        }

        [HttpPost]
        public async Task<ActionResult<Crypto>> AddCrypto(CreateCryptoDto createCryptoDto)
        {
            Portfolio portfolio =
                await database.Portfolios.Include(p => p.Stocks)
                    .FirstOrDefaultAsync(p => p.Id == createCryptoDto.PortfolioId);

            if (portfolio == null) return BadRequest("Portfolio " + createCryptoDto.PortfolioId + " does not exist");
            if (portfolio.Cryptos == null) portfolio.Cryptos = new List<Crypto>();
            
            var target = portfolio.Cryptos.Where(crypto => string.Equals(crypto.Name, createCryptoDto.Name, StringComparison.OrdinalIgnoreCase)).FirstOrDefault();
            
            if(target != null) return BadRequest("Crypto " + createCryptoDto.Name + " does already exist");

            var crypto = new Crypto
            {
                Portfolio = portfolio,
                Name = createCryptoDto.Name, 
                Isin = createCryptoDto.Isin,
                Quantity = createCryptoDto.Quantity,
                BoughtAt = DateTime.Now
            };
            
            portfolio.Cryptos.Add(crypto);
            database.Portfolios.Update(portfolio);
            await database.SaveChangesAsync();
            crypto.Portfolio.Stocks = null;
            crypto.Portfolio.Cryptos = null;
            return Ok(crypto);
        }

        [HttpPut]
        public async Task<ActionResult<Crypto>> UpdateCrypto(CreateCryptoDto createCryptoDto)
        {
            Portfolio portfolio =
                await database.Portfolios.Include(p => p.Stocks)
                    .FirstOrDefaultAsync(p => p.Id == createCryptoDto.PortfolioId);

            if (portfolio == null) return BadRequest("Portfolio " + createCryptoDto.PortfolioId + " does not exist");
            
            Crypto targetCrypto = await database.Cryptos.FindAsync(createCryptoDto.Id);
            if (targetCrypto == null)
            {
                return BadRequest("Crypto with id: " + createCryptoDto.Id + " does not exist");
            }

            var crypto = new Crypto
            {
                Id = targetCrypto.Id,
                Portfolio = targetCrypto.Portfolio,
                Name = createCryptoDto.Name,
                Isin = createCryptoDto.Isin,
                Quantity = createCryptoDto.Quantity,
                BoughtAt = DateTime.Now
            };

            targetCrypto = crypto;

            database.Cryptos.Update(targetCrypto);
            await database.SaveChangesAsync();
            
            return Ok(crypto);
        }
    }
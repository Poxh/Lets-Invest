using Microsoft.AspNetCore.Mvc;
using lets_invest_api.Models;
using lets_invest_api.Dto;
using Microsoft.EntityFrameworkCore;

namespace lets_invest_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StockController : ControllerBase
    {
        private readonly Database database;

        public StockController(Database _database) {
            database = _database;    
        }
        
        [HttpGet]
        public async Task<ActionResult<ICollection<Stock>>> GetStocks([FromQuery] string DisplayName)
        {
            return Ok(await database.Stocks.Where(p => p.Portfolio.User.DisplayName == DisplayName).ToListAsync());
        }

        [HttpPost]
        public async Task<ActionResult<Stock>> AddStock(CreateStockDto createStockDto)
        {
            Portfolio portfolio =
                await database.Portfolios.Include(p => p.Stocks)
                    .FirstOrDefaultAsync(p => p.Id == createStockDto.PortfolioId);

            if (portfolio == null) return BadRequest("Portfolio " + createStockDto.PortfolioId + " does not exist");
            
            if(portfolio.Stocks.Where(s => s.Name == createStockDto.Name).ToList().Count > 0) return BadRequest("Stock " + createStockDto.Name + " does already exist");

            var stock = new Stock
            {
                Portfolio = portfolio,
                Name = createStockDto.Name, 
                Isin = createStockDto.Isin,
                Quantity = createStockDto.Quantity,
                BoughtAt = DateTime.Now
            };
            
            portfolio.Stocks.Add(stock);
            database.Portfolios.Update(portfolio);
            await database.SaveChangesAsync();
            stock.Portfolio.Stocks = null;
            return Ok(stock);
        }

        [HttpPut]
        public async Task<ActionResult<Stock>> UpdateStock(CreateStockDto createStockDto)
        {
            Portfolio portfolio =
                await database.Portfolios.Include(p => p.Stocks)
                    .FirstOrDefaultAsync(p => p.Id == createStockDto.PortfolioId);

            if (portfolio == null) return BadRequest("Portfolio " + createStockDto.PortfolioId + " does not exist");
            
            Stock targetStock = await database.Stocks.FindAsync(createStockDto.Id);
            if (targetStock == null)
            {
                return BadRequest("Stock with id: " + createStockDto.Id + " does not exist");
            }

            var stock = new Stock
            {
                Id = targetStock.Id,
                Portfolio = targetStock.Portfolio,
                Name = createStockDto.Name,
                Isin = createStockDto.Isin,
                Quantity = createStockDto.Quantity,
                BoughtAt = DateTime.Now
            };

            targetStock = stock;

            database.Stocks.Update(targetStock);
            await database.SaveChangesAsync();
            
            return Ok(stock);
        }
    }
}
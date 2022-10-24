using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using lets_invest_api.Models;
using lets_invest_api.Dto;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace lets_invest_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly Database database;

        public UserController(Database _database) {
            database = _database;    
        }

        [HttpGet]
        public async Task<ActionResult<User>> Get()
        {
            User user = await database.Users.Include(u => u.Portfolio).FirstAsync(u => u.Id == 4);
            user.Portfolio.User = null;
            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult<User>> AddUser(CreateUserDto user) 
        {
            Portfolio portfolio = new() {
                IsPublic = true,
                Cash = user.CreatePortfolioDto.Cash,
            };

            User finalUser = new() {
                DisplayName = user.DisplayName,
                ProfilePicture = user.ProfilePicture,
                Portfolio = portfolio
            };

            database.Users.Add(finalUser);
            await database.SaveChangesAsync();
            finalUser.Portfolio.User = null;
            return Ok(finalUser);
        }

        [HttpPut]
        public async Task<ActionResult<User>> UpdateUser(CreateUserDto createUserDto)
        {
            User user = await database.Users.Include(u => u.Portfolio)
                .FirstOrDefaultAsync(u => u.Id == createUserDto.Id);
            if (user == null) return BadRequest("User with id: " + createUserDto.Id + " not found");

            Portfolio portfolio = new()
            {
                Id = user.Portfolio.Id,
                IsPublic = createUserDto.CreatePortfolioDto.IsPublic,
                Cash = createUserDto.CreatePortfolioDto.Cash,
                Stocks = createUserDto.CreatePortfolioDto.stocks,
                Cryptos = createUserDto.CreatePortfolioDto.cryptos
            };

            user.Portfolio = portfolio;
            user.DisplayName = createUserDto.DisplayName;
            user.ProfilePicture = createUserDto.ProfilePicture;
            database.Users.Update(user);
            await database.SaveChangesAsync();
            user.Portfolio.User = null;
            return Ok(user);
        }
    }
}

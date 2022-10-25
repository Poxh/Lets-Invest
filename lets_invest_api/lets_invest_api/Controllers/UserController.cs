using Microsoft.AspNetCore.Mvc;
using lets_invest_api.Models;
using lets_invest_api.Dto;
using lets_invest_api.Dto.Update;
using Microsoft.EntityFrameworkCore;

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
        public async Task<ActionResult<User>> Get([FromQuery] string DisplayName)
        {
            if (!await UserExists(DisplayName)) return BadRequest(DisplayName + " does not exist");
            User target = await database.Users.Include(u => u.Portfolio).FirstAsync(u => u.DisplayName == DisplayName);
            target.Portfolio.User = null;
            return Ok(target);
        }

        [HttpPost]
        public async Task<ActionResult<User>> AddUser(CreateUserDto user) 
        {
            if (await UserExists(user.DisplayName)) return BadRequest(user.DisplayName + " does exist");
            
            Portfolio portfolio = new() {
                IsPublic = true,
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
        public async Task<ActionResult<User>> UpdateUser(UpdateUserDto updateUserDto)
        {
            User user = await database.Users.Include(u => u.Portfolio)
                .FirstOrDefaultAsync(u => u.Id == updateUserDto.Id);
            if (user == null) return BadRequest("User with id: " + updateUserDto.Id + " not found");
            if (user.DisplayName == updateUserDto.DisplayName) return BadRequest("Please make changes to update your display name");
            if (await UserExists(updateUserDto.DisplayName)) return BadRequest("User with name: " + updateUserDto.DisplayName + " already exists");

            user.DisplayName = updateUserDto.DisplayName;
            user.ProfilePicture = updateUserDto.ProfilePicture;
            database.Users.Update(user);
            await database.SaveChangesAsync();
            user.Portfolio.User = null;
            return Ok(user);
        }

        async Task<bool> UserExists(string DisplayName)
        {
            return await database.Users.AsQueryable()
                .AnyAsync(u => EF.Functions.Like(u.DisplayName, $"{DisplayName}"));
        }
    }
}

namespace lets_invest_api.Dto
{
    public class CreateUserDto
    {
        public int Id { get; set; }
        public string DisplayName { get; set; }

        public string ProfilePicture { get; set; }

        public CreatePortfolioDto CreatePortfolioDto { get; set; }
    }
}

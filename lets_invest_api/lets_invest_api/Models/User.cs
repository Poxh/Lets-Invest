namespace lets_invest_api.Models
{
    public class User
    {
        public int Id { get; set; }

        public string DisplayName { get; set; }

        public string ProfilePicture { get; set; }

        public Portfolio Portfolio { get; set; }
    }
}

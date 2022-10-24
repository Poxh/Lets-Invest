using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace lets_invest_api.Migrations
{
    public partial class PortfolioUserOneToOne : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_Portfolio_PortfolioId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_PortfolioId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "PortfolioId",
                table: "Users");

            migrationBuilder.AddColumn<int>(
                name: "UserId",
                table: "Portfolio",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Portfolio_UserId",
                table: "Portfolio",
                column: "UserId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Portfolio_Users_UserId",
                table: "Portfolio",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Portfolio_Users_UserId",
                table: "Portfolio");

            migrationBuilder.DropIndex(
                name: "IX_Portfolio_UserId",
                table: "Portfolio");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Portfolio");

            migrationBuilder.AddColumn<int>(
                name: "PortfolioId",
                table: "Users",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Users_PortfolioId",
                table: "Users",
                column: "PortfolioId");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Portfolio_PortfolioId",
                table: "Users",
                column: "PortfolioId",
                principalTable: "Portfolio",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}

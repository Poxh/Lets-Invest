using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace lets_invest_api.Migrations
{
    public partial class AddedPortfolioToStock : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Crypto_Portfolio_PortfolioId",
                table: "Crypto");

            migrationBuilder.DropForeignKey(
                name: "FK_Portfolio_Users_UserId",
                table: "Portfolio");

            migrationBuilder.DropForeignKey(
                name: "FK_Stocks_Portfolio_PortfolioId",
                table: "Stocks");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Portfolio",
                table: "Portfolio");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Crypto",
                table: "Crypto");

            migrationBuilder.RenameTable(
                name: "Portfolio",
                newName: "Portfolios");

            migrationBuilder.RenameTable(
                name: "Crypto",
                newName: "Cryptos");

            migrationBuilder.RenameIndex(
                name: "IX_Portfolio_UserId",
                table: "Portfolios",
                newName: "IX_Portfolios_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_Crypto_PortfolioId",
                table: "Cryptos",
                newName: "IX_Cryptos_PortfolioId");

            migrationBuilder.AlterColumn<int>(
                name: "PortfolioId",
                table: "Stocks",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Portfolios",
                table: "Portfolios",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Cryptos",
                table: "Cryptos",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos",
                column: "PortfolioId",
                principalTable: "Portfolios",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Portfolios_Users_UserId",
                table: "Portfolios",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Stocks_Portfolios_PortfolioId",
                table: "Stocks",
                column: "PortfolioId",
                principalTable: "Portfolios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos");

            migrationBuilder.DropForeignKey(
                name: "FK_Portfolios_Users_UserId",
                table: "Portfolios");

            migrationBuilder.DropForeignKey(
                name: "FK_Stocks_Portfolios_PortfolioId",
                table: "Stocks");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Portfolios",
                table: "Portfolios");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Cryptos",
                table: "Cryptos");

            migrationBuilder.RenameTable(
                name: "Portfolios",
                newName: "Portfolio");

            migrationBuilder.RenameTable(
                name: "Cryptos",
                newName: "Crypto");

            migrationBuilder.RenameIndex(
                name: "IX_Portfolios_UserId",
                table: "Portfolio",
                newName: "IX_Portfolio_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_Cryptos_PortfolioId",
                table: "Crypto",
                newName: "IX_Crypto_PortfolioId");

            migrationBuilder.AlterColumn<int>(
                name: "PortfolioId",
                table: "Stocks",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Portfolio",
                table: "Portfolio",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Crypto",
                table: "Crypto",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Crypto_Portfolio_PortfolioId",
                table: "Crypto",
                column: "PortfolioId",
                principalTable: "Portfolio",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Portfolio_Users_UserId",
                table: "Portfolio",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Stocks_Portfolio_PortfolioId",
                table: "Stocks",
                column: "PortfolioId",
                principalTable: "Portfolio",
                principalColumn: "Id");
        }
    }
}

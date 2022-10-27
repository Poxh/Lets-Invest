using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace lets_invest_api.Migrations
{
    public partial class PortfolioSet : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Stock_Portfolio_PortfolioId",
                table: "Stock");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Stock",
                table: "Stock");

            migrationBuilder.DropColumn(
                name: "Value",
                table: "Portfolio");

            migrationBuilder.DropColumn(
                name: "Price",
                table: "Crypto");

            migrationBuilder.RenameTable(
                name: "Stock",
                newName: "Stocks");

            migrationBuilder.RenameIndex(
                name: "IX_Stock_PortfolioId",
                table: "Stocks",
                newName: "IX_Stocks_PortfolioId");

            migrationBuilder.AddColumn<string>(
                name: "Isin",
                table: "Crypto",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<double>(
                name: "Quantity",
                table: "Crypto",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<string>(
                name: "Isin",
                table: "Stocks",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Stocks",
                table: "Stocks",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Stocks_Portfolio_PortfolioId",
                table: "Stocks",
                column: "PortfolioId",
                principalTable: "Portfolio",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Stocks_Portfolio_PortfolioId",
                table: "Stocks");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Stocks",
                table: "Stocks");

            migrationBuilder.DropColumn(
                name: "Isin",
                table: "Crypto");

            migrationBuilder.DropColumn(
                name: "Quantity",
                table: "Crypto");

            migrationBuilder.DropColumn(
                name: "Isin",
                table: "Stocks");

            migrationBuilder.RenameTable(
                name: "Stocks",
                newName: "Stock");

            migrationBuilder.RenameIndex(
                name: "IX_Stocks_PortfolioId",
                table: "Stock",
                newName: "IX_Stock_PortfolioId");

            migrationBuilder.AddColumn<double>(
                name: "Value",
                table: "Portfolio",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<int>(
                name: "Price",
                table: "Crypto",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Stock",
                table: "Stock",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Stock_Portfolio_PortfolioId",
                table: "Stock",
                column: "PortfolioId",
                principalTable: "Portfolio",
                principalColumn: "Id");
        }
    }
}

import database
import flet as ft


def main(page: ft.Page):
    page.title = "Filament Manager"

    spools = database.get_all_spools()

    for spool in spools:
        page.add(ft.Text(f"{spool[1]} - {spool[2]} - {spool[3]}"))

    page.update()


ft.app(target=main)


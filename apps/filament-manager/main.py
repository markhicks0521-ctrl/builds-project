import database
import flet as ft


def main(page: ft.Page):
    page.title = "Filament Manager"

    brand_input = ft.TextField(label="Brand")
    material_input = ft.TextField(label="Material")
    color_input = ft.TextField(label="color")
    weight_input = ft.TextField(label="Total Weight (g)")

    spool_list = ft.Column()

    def refresh_spool_list():
        spool_list.controls.clear()
        for spool in database.get_all_spools():
            spool_list.controls.append(ft.Text(f"{spool[1]} - {spool[2]} - {spool[3]} - {spool[5]}g / {spool[4]}g"))
        page.update()

    def add_spool_clicked(e):
        database.add_spool(
            brand_input.value,
            material_input.value,
            color_input.value,
            float(weight_input.value),
            float(weight_input.value),
        )
        brand_input.value = ""
        material_input.value = ""
        color_input.value = ""
        weight_input.value = ""
        refresh_spool_list()

    add_button = ft.ElevatedButton(content="Add Spool", on_click=add_spool_clicked)

    page.add(brand_input, material_input, color_input, weight_input, add_button, spool_list)

    refresh_spool_list()



ft.app(target=main)


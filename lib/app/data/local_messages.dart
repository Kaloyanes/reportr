import 'package:get/get.dart';

class LocalMessages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "sign_in": "Sign in",
          "create_account": "Create account",
          "email": "Email",
          "password": "Password",
          "confirm_password": "Confirm password",
          "sign": "Sign In",
          "sign_up": "Sign Up",
          "fill_field": "Please fill this field",
          "forgot_password": "Forgot password",
          "forgot_password_description":
              "Enter your email to reset your password",
          "cancel": "Cancel",
          "submit": "Submit",
          "success_login": "You have successfully logged in",
          "invalid_email": "Please enter a valid email",
          "email_already_in_use": "This email is already in use",
          "weak_password": "Password must be at least 6 characters long",
          "name": "Name",
          "type_account": "Type of account",
          "reporter": "Reporter",
          "organization": "Organization",
          "employee": "Employee",
          "code": "Code",
          "create": "Sign up",
          "organization_location": "Organization location",
          "choose_color_for_organization": "Choose color for organization",
          "organization_name": "Organization name",
          "reports": "Reports",
          "my_reports": "My reports",
          "chats": "Chats",
          "workers": "Workers",
          "profile": "Profile",
          "sign_out": "Sign out",
          "file": "File",
          "picture": "Picture",
          "delete_profile": "Delete profile",
          "generate_new_code": "Generate new code",
          "organization_code_for_invite": "Organization code for invite",
          "leave_organization": "Leave organization",
          "leave_organization_question":
              "Are you sure you want to leave this organization?",
          "place_new_organization": "Join new organization",
          "yes": "Yes",
          "no": "No",
          "ok": "Ok",
          "choose_option": "Choose option",
          "camera": "Camera",
          "gallery": "Gallery",
          "save": "Save",
          "delete_profile_picture": "Delete profile picture",
          "add_picture": "Add picture",
          "save_changes_question": "Do you want to save changes?",
          "report_click_circle": "Click on a circle to report",
          "report_to": "Report to @organization",
          "report_name": "Title",
          "report_description": "Description",
          "anonymous_report": "Anonymous report?",
          "report": "Report",
          "no_pictures_error": "You can't have no pictures",
          "report_success": "You have successfully reported",
          "rate": "Rate",
          "rate_report_by_priority": "Rate report by priority",
          "description": "Description",
          "most_recent": "Most recent",
          "top_priority": "Top priority",
          "remove_user": "Remove user",
          "start_download": "Started download of @file",
          "finished_download": "Finished download of @file",
          "delete_message": "Delete message",
          "type_message": "Type here...",
          "cant_type_to_yourself": "You can't type to yourself",
          "required_account_to_chat": "You need to have an account to chat",
          "changed_rating": "You have successfully changed the rating",
          "settings": "Settings",
          "change_language": "Change language",
          "language": "Language",
          "delete_forever_report": "Do you want to delete the report forever?",
          "assign_to_department": "Assign to department",
          "assigned_to_department": "Assigned to department: @department",
          "anonymous": "Anonymous",
          "get_started": "Get Started",
          "welcome": "Welcome to ReportR",
          "create_department": "Create department",
          "remove_department": "Remove department",
          "remove_department_confirm":
              "Do you want to remove the department @department?",
          "no_department": "No department",
          "assign_user": "Assign user",
          "remove_from_department": "Remove from department",
          "confirm": "Confirm",
          "choose_department": "Choose department",
          "user_assigned": "User assigned",
          "ai_department": "AI Department",
          "report_assigned_to_department":
              "Report assigned to department @department",
          "department_removed": "Department @department removed",
          "department_created": "Department @department created",
          "no_reports": "No reports",
          "remove_user_from_department_question":
              "Are you sure you want to remove @employee from @department?",
          "joined_organization": "Joined organization",
          "remove_user_from_organization":
              "Are you sure you want to remove @employee from the organization?"
        },
        'bg_BG': {
          "sign_in": "Вход",
          "create_account": "Създай акаунт",
          "email": "Имейл",
          "password": "Парола",
          "confirm_password": "Потвърдете паролата",
          "sign": "Влез",
          "sign_up": "Регистрация",
          "fill_field": "Моля, попълнете това поле",
          "forgot_password": "Забравена парола",
          "forgot_password_description":
              "Въведете вашия имейл, за да нулирате паролата си",
          "cancel": "Отказ",
          "submit": "Изпрати",
          "success_login": "Успешно влязохте в системата",
          "invalid_email": "Моля, въведете валиден имейл",
          "email_already_in_use": "Този имейл вече се използва",
          "weak_password": "Паролата трябва да бъде поне 6 символа",
          "name": "Име",
          "type_account": "Тип акаунт",
          "reporter": "Репортер",
          "organization": "Организация",
          "employee": "Служител",
          "code": "Код",
          "create": "Регистрирай се",
          "organization_location": "Местоположение на организацията",
          "choose_color_for_organization": "Изберете цвят за организацията",
          "organization_name": "Име на организацията",
          "reports": "Доклади",
          "my_reports": "Моите доклади",
          "chats": "Чатове",
          "workers": "Работници",
          "profile": "Профил",
          "sign_out": "Изход",
          "file": "Файл",
          "picture": "Снимка",
          "delete_profile": "Изтрий профила",
          "generate_new_code": "Генерирай нов код",
          "organization_code_for_invite": "Код на организацията за покана",
          "leave_organization": "Напусни организацията",
          "leave_organization_question":
              "Сигурни ли сте, че искате да напуснете тази организация?",
          "place_new_organization": "Присъедини се към нова организация",
          "yes": "Да",
          "no": "Не",
          "ok": "Ок",
          "choose_option": "Изберете опция",
          "camera": "Камера",
          "gallery": "Галерия",
          "save": "Запази",
          "delete_profile_picture": "Изтрий снимката на профила",
          "add_picture": "Добави снимка",
          "save_changes_question": "Искате ли да запазите промените?",
          "report_click_circle": "Кликнете върху кръг, за да докладвате",
          "report_to": "Докладвайте до @organization",
          "report_name": "Заглавие",
          "report_description": "Описание",
          "anonymous_report": "Анонимен доклад?",
          "report": "Доклад",
          "no_pictures_error": "Не можете да нямате снимки",
          "report_success": "Успешно подадохте доклад",
          "rate": "Оценете",
          "rate_report_by_priority": "Оценете доклада по приоритет",
          "description": "Описание",
          "most_recent": "Най-скорошни",
          "top_priority": "Най-висок приоритет",
          "remove_user": "Премахни потребител",
          "start_download": "Започнато изтегляне на @file",
          "finished_download": "Завършено изтегляне на @file",
          "delete_message": "Изтрий съобщение",
          "type_message": "Пишете тук...",
          "cant_type_to_yourself": "Не можете да пишете на себе си",
          "required_account_to_chat": "Трябва да имате акаунт, за да чатите",
          "changed_rating": "Успешно променихте оценката",
          "settings": "Настройки",
          "change_language": "Смени езика",
          "language": "Език",
          "delete_forever_report": "Искате ли да изтриете доклада завинаги?",
          "assign_to_department": "Назначете на отдел",
          "assigned_to_department": "Назначен на отдел: @department",
          "anonymous": "Анонимен",
          "get_started": "Започнете",
          "welcome": "Добре дошли в ReportR",
          "create_department": "Създай отдел",
          "remove_department": "Премахни отдел",
          "remove_department_confirm":
              "Искате ли да премахнете отдел @department?",
          "no_department": "Без отдел",
          "assign_user": "Назначете потребител",
          "remove_from_department": "Премахнете от отдел",
          "confirm": "Потвърди",
          "choose_department": "Изберете отдел",
          "user_assigned": "Назначен потребител",
          "ai_department": "Отдел по изкуствен интелект",
          "report_assigned_to_department":
              "Докладът е назначен на отдел @department",
          "department_removed": "Отдел @department е премахнат",
          "department_created": "Създаден е отдел @department",
          "no_reports": "Няма доклади",
          "remove_user_from_department_question":
              "Сигурни ли сте, че искате да премахнете @employee от @department?",
          "joined_organization": "Присъединен към организация",
          "remove_user_from_organization":
              "Сигурни ли сте, че искате да премахнете @employee от организацията?"
        },
        'de_DE': {
          "sign_in": "Anmelden",
          "create_account": "Konto erstellen",
          "email": "E-Mail",
          "password": "Passwort",
          "confirm_password": "Passwort bestätigen",
          "sign": "Einloggen",
          "sign_up": "Registrieren",
          "fill_field": "Bitte füllen Sie dieses Feld aus",
          "forgot_password": "Passwort vergessen",
          "forgot_password_description":
              "Geben Sie Ihre E-Mail ein, um Ihr Passwort zurückzusetzen",
          "cancel": "Abbrechen",
          "submit": "Absenden",
          "success_login": "Sie haben sich erfolgreich angemeldet",
          "invalid_email": "Bitte geben Sie eine gültige E-Mail-Adresse ein",
          "email_already_in_use": "Diese E-Mail wird bereits verwendet",
          "weak_password": "Das Passwort muss mindestens 6 Zeichen lang sein",
          "name": "Name",
          "type_account": "Kontoart",
          "reporter": "Reporter",
          "organization": "Organisation",
          "employee": "Mitarbeiter",
          "code": "Code",
          "create": "Anmelden",
          "organization_location": "Standort der Organisation",
          "choose_color_for_organization":
              "Wählen Sie eine Farbe für die Organisation",
          "organization_name": "Name der Organisation",
          "reports": "Berichte",
          "my_reports": "Meine Berichte",
          "chats": "Chats",
          "workers": "Mitarbeiter",
          "profile": "Profil",
          "sign_out": "Abmelden",
          "file": "Datei",
          "picture": "Bild",
          "delete_profile": "Profil löschen",
          "generate_new_code": "Neuen Code generieren",
          "organization_code_for_invite": "Einladungscode der Organisation",
          "leave_organization": "Organisation verlassen",
          "leave_organization_question":
              "Sind Sie sicher, dass Sie diese Organisation verlassen möchten?",
          "place_new_organization": "Neuer Organisation beitreten",
          "yes": "Ja",
          "no": "Nein",
          "ok": "Ok",
          "choose_option": "Option wählen",
          "camera": "Kamera",
          "gallery": "Galerie",
          "save": "Speichern",
          "delete_profile_picture": "Profilbild löschen",
          "add_picture": "Bild hinzufügen",
          "save_changes_question": "Möchten Sie die Änderungen speichern?",
          "report_click_circle": "Klicken Sie auf einen Kreis, um zu berichten",
          "report_to": "Bericht an @organization",
          "report_name": "Titel",
          "report_description": "Beschreibung",
          "anonymous_report": "Anonymer Bericht?",
          "report": "Bericht",
          "no_pictures_error": "Sie können nicht ohne Bilder sein",
          "report_success": "Sie haben erfolgreich berichtet",
          "rate": "Bewerten",
          "rate_report_by_priority": "Bericht nach Priorität bewerten",
          "description": "Beschreibung",
          "most_recent": "Am neuesten",
          "top_priority": "Höchste Priorität",
          "remove_user": "Benutzer entfernen",
          "start_download": "Download von @file gestartet",
          "finished_download": "Download von @file abgeschlossen",
          "delete_message": "Nachricht löschen",
          "type_message": "Hier tippen...",
          "cant_type_to_yourself": "Sie können sich nicht selbst schreiben",
          "required_account_to_chat": "Sie benötigen ein Konto, um zu chatten",
          "changed_rating": "Sie haben die Bewertung erfolgreich geändert",
          "settings": "Einstellungen",
          "change_language": "Sprache ändern",
          "language": "Sprache",
          "delete_forever_report": "Möchten Sie den Bericht für immer löschen?",
          "assign_to_department": "Zu Abteilung zuweisen",
          "assigned_to_department": "Zu Abteilung zugewiesen: @department",
          "anonymous": "Anonym",
          "get_started": "Loslegen",
          "welcome": "Willkommen bei ReportR",
          "create_department": "Abteilung erstellen",
          "remove_department": "Abteilung entfernen",
          "remove_department_confirm":
              "Möchten Sie die Abteilung @department wirklich entfernen?",
          "no_department": "Keine Abteilung",
          "assign_user": "Benutzer zuweisen",
          "remove_from_department": "Aus Abteilung entfernen",
          "confirm": "Bestätigen",
          "choose_department": "Abteilung wählen",
          "user_assigned": "Benutzer zugewiesen",
          "ai_department": "KI-Abteilung",
          "report_assigned_to_department":
              "Bericht der Abteilung @department zugewiesen",
          "department_removed": "Abteilung @department entfernt",
          "department_created": "Abteilung @department erstellt",
          "no_reports": "Keine Berichte",
          "remove_user_from_department_question":
              "Sind Sie sicher, dass Sie @employee aus @department entfernen möchten?",
          "joined_organization": "Organisation beigetreten",
          "remove_user_from_organization":
              "Sind Sie sicher, dass Sie @employee aus der Organisation entfernen möchten?"
        },
        'ru_RU': {
          "sign_in": "Войти",
          "create_account": "Создать аккаунт",
          "email": "Электронная почта",
          "password": "Пароль",
          "confirm_password": "Подтвердите пароль",
          "sign": "Вход",
          "sign_up": "Регистрация",
          "fill_field": "Пожалуйста, заполните это поле",
          "forgot_password": "Забыли пароль",
          "forgot_password_description":
              "Введите вашу электронную почту для сброса пароля",
          "cancel": "Отмена",
          "submit": "Отправить",
          "success_login": "Вы успешно вошли в систему",
          "invalid_email":
              "Пожалуйста, введите действительный адрес электронной почты",
          "email_already_in_use":
              "Этот адрес электронной почты уже используется",
          "weak_password": "Пароль должен быть не менее 6 символов",
          "name": "Имя",
          "type_account": "Тип аккаунта",
          "reporter": "Репортер",
          "organization": "Организация",
          "employee": "Сотрудник",
          "code": "Код",
          "create": "Зарегистрироваться",
          "organization_location": "Местоположение организации",
          "choose_color_for_organization": "Выберите цвет для организации",
          "organization_name": "Название организации",
          "reports": "Отчеты",
          "my_reports": "Мои отчеты",
          "chats": "Чаты",
          "workers": "Работники",
          "profile": "Профиль",
          "sign_out": "Выйти",
          "file": "Файл",
          "picture": "Изображение",
          "delete_profile": "Удалить профиль",
          "generate_new_code": "Сгенерировать новый код",
          "organization_code_for_invite": "Код организации для приглашения",
          "leave_organization": "Покинуть организацию",
          "leave_organization_question":
              "Вы уверены, что хотите покинуть эту организацию?",
          "place_new_organization": "Вступить в новую организацию",
          "yes": "Да",
          "no": "Нет",
          "ok": "Ок",
          "choose_option": "Выбрать опцию",
          "camera": "Камера",
          "gallery": "Галерея",
          "save": "Сохранить",
          "delete_profile_picture": "Удалить фотографию профиля",
          "add_picture": "Добавить изображение",
          "save_changes_question": "Хотите сохранить изменения?",
          "report_click_circle": "Нажмите на круг, чтобы сообщить",
          "report_to": "Сообщить в @organization",
          "report_name": "Название",
          "report_description": "Описание",
          "anonymous_report": "Анонимное сообщение?",
          "report": "Сообщить",
          "no_pictures_error": "Вы не можете не иметь изображений",
          "report_success": "Вы успешно отправили сообщение",
          "rate": "Оценить",
          "rate_report_by_priority": "Оценить сообщение по приоритету",
          "description": "Описание",
          "most_recent": "Самые последние",
          "top_priority": "Наивысший приоритет",
          "remove_user": "Удалить пользователя",
          "start_download": "Начато скачивание @file",
          "finished_download": "Скачивание @file завершено",
          "delete_message": "Удалить сообщение",
          "type_message": "Напишите здесь...",
          "cant_type_to_yourself": "Вы не можете писать себе",
          "required_account_to_chat": "Для общения в чате необходим аккаунт",
          "changed_rating": "Вы успешно изменили рейтинг",
          "settings": "Настройки",
          "change_language": "Изменить язык",
          "language": "Язык",
          "delete_forever_report": "Вы хотите навсегда удалить отчет?",
          "assign_to_department": "Назначить в отдел",
          "assigned_to_department": "Назначен в отдел: @department",
          "anonymous": "Анонимно",
          "get_started": "Начать",
          "welcome": "Добро пожаловать в ReportR",
          "create_department": "Создать отдел",
          "remove_department": "Удалить отдел",
          "remove_department_confirm":
              "Вы действительно хотите удалить отдел @department?",
          "no_department": "Нет отдела",
          "assign_user": "Назначить пользователя",
          "remove_from_department": "Удалить из отдела",
          "confirm": "Подтвердить",
          "choose_department": "Выбрать отдел",
          "user_assigned": "Пользователь назначен",
          "ai_department": "Отдел ИИ",
          "report_assigned_to_department": "Отчет назначен отделу @department",
          "department_removed": "Отдел @department удален",
          "department_created": "Отдел @department создан",
          "no_reports": "Нет отчетов",
          "remove_user_from_department_question":
              "Вы уверены, что хотите удалить @employee из отдела @department?",
          "joined_organization": "Присоединился к организации",
          "remove_user_from_organization":
              "Вы уверены, что хотите удалить @employee из организации?"
        },
      };
}

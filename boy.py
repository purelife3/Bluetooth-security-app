import os
import psycopg2
from datetime import datetime
from dotenv import load_dotenv
from telegram import Update, ChatMemberUpdated
from telegram.ext import (
    ApplicationBuilder,
    CommandHandler,
    MessageHandler,
    ChatMemberHandler,
    filters,
    ContextTypes,
)

load_dotenv()

BOT_TOKEN = os.getenv("BOT_TOKEN")
DATABASE_URL = os.getenv("DATABASE_URL")

conn = psycopg2.connect(DATABASE_URL)
conn.autocommit = True


def upsert_user(user):
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO tg_users (id, username, first_name, last_name, first_seen, last_seen)
            VALUES (%s, %s, %s, %s, NOW(), NOW())
            ON CONFLICT (id) DO UPDATE
            SET username = EXCLUDED.username,
                first_name = EXCLUDED.first_name,
                last_name = EXCLUDED.last_name,
                last_seen = NOW();
            """,
            (user.id, user.username, user.first_name, user.last_name),
        )


def log_membership_event(user_id, chat_id, event_type):
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO tg_membership_events (user_id, chat_id, event_type, event_at)
            VALUES (%s, %s, %s, NOW());
            """,
            (user_id, chat_id, event_type),
        )


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    upsert_user(user)
    await update.message.reply_text("Hi! I will help manage this channel/group.")


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    if user:
        upsert_user(user)


async def handle_chat_member(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_member_update: ChatMemberUpdated = update.chat_member
    user = chat_member_update.from_user
    chat = chat_member_update.chat
    upsert_user(user)

    old_status = chat_member_update.old_chat_member.status
    new_status = chat_member_update.new_chat_member.status

    if old_status in ("left", "kicked") and new_status in ("member", "administrator"):
        log_membership_event(user.id, chat.id, "join")
    elif old_status in ("member", "administrator") and new_status == "left":
        log_membership_event(user.id, chat.id, "leave")
    elif new_status == "kicked":
        log_membership_event(user.id, chat.id, "ban")


async def stats(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat = update.effective_chat
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT COUNT(DISTINCT user_id)
            FROM tg_membership_events
            WHERE chat_id = %s;
            """,
            (chat.id,),
        )
        total = cur.fetchone()[0] or 0
    await update.message.reply_text(f"Known members for this chat: {total}")


async def main():
    app = ApplicationBuilder().token(BOT_TOKEN).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("stats", stats))
    app.add_handler(MessageHandler(filters.ALL, handle_message))
    app.add_handler(ChatMemberHandler(handle_chat_member, ChatMemberHandler.CHAT_MEMBER))

    await app.run_polling()


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
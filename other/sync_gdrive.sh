# don't copy from gdrive -> local or there's high risk of losing passwords!!!
# more work to do if 2way is needed. Probably not needed.
#rclone copy --backup-dir ~/rclone/backups gdrive: ~/rclone/gdrive

# run rclone config first to refresh access token, then run this:
rclone copy -vv --backup-dir gdrive:/rclone_backup /home/kuro/rclone/gdrive gdrive:/rclone

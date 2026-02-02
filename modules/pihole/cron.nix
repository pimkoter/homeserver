{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* 0 * * * root docker exec pihole pihole updateGravity"
    ];
  };
}

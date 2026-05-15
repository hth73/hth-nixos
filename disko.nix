{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "fat";
            mountpoint = "/boot";
          };
        };

        swap = {
          size = "2G";

          content = {
            type = "swap";
            randomEncryption = false;
          };
        };

        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}

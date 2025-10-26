# expert-octo-succotash
ECS, EFS and Grafana PoC


This error is because the VPC is IPv6 enabled, so the security groups and EFS also need to be considered.

```

Task is stopping
ResourceInitializationError: failed to invoke EFS utils commands to set up EFS volumes: stderr: Mount attempt 1/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. Mount attempt 2/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. b'mount.nfs4: mount system call failed' Traceback (most recent call last): File "/usr/sbin/supervisor_mount_efs", line 52, in <module> return_code = subprocess.check_call(["mount", "-t", "efs", "-o", opts, args.fs_id_with_path, args.dir_in_container], shell=False) File "/usr/lib64/python3.9/subprocess.py", line 373, in check_call raise CalledProcessError(retcode, cmd) subprocess.CalledProcessError: Command '['mount', '-t', 'efs', '-o', 'noresvport', 'fs-03b924b6fb7476e29:/', '/efs-vols/grafana-db']' returned non-zero exit status 32. During handling of the above exception, another exception occurred: Traceback (most recent call last): File "/usr/sbin/supervisor_mount_efs", line 56, in <module> "message": err.message, : unsuccessful EFS utils comma


ResourceInitializationError: failed to invoke EFS utils commands to set up EFS volumes: stderr: Mount attempt 1/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. Mount attempt 2/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. b'mount.nfs4: mount system call failed' Traceback (most recent call last): File "/usr/sbin/supervisor_mount_efs", line 52, in <module> return_code = subprocess.check_call(["mount", "-t", "efs", "-o", opts, args.fs_id_with_path, args.dir_in_container], shell=False) File "/usr/lib64/python3.9/subprocess.py", line 373, in check_call raise CalledProcessError(retcode, cmd) subprocess.CalledProcessError: Command '['mount', '-t', 'efs', '-o', 'noresvport,tls,iam,awscredsuri=/v2/credentials/7434175f-960f-4cd0-9109-0ca20220d48e', 'fs-05c2ef343d6298f23:/', '/efs-vols/grafana-db']' returned non-zero exit status 32. During handling of the above exception, another exception occurred: Traceback (most recent call last): File "/usr/sbin: unsuccessful EFS utils c


ResourceInitializationError: failed to invoke EFS utils commands to set up EFS volumes: stderr: Mount attempt 1/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. Mount attempt 2/3 failed due to timeout after 15 sec, wait 0 sec before next attempt. b'mount.nfs4: mount system call failed' Traceback (most recent call last): File "/usr/sbin/supervisor_mount_efs", line 52, in <module> return_code = subprocess.check_call(["mount", "-t", "efs", "-o", opts, args.fs_id_with_path, args.dir_in_container], shell=False) File "/usr/lib64/python3.9/subprocess.py", line 373, in check_call raise CalledProcessError(retcode, cmd) subprocess.CalledProcessError: Command '['mount', '-t', 'efs', '-o', 'noresvport,tls,iam,awscredsuri=/v2/credentials/bd41b615-e665-44a5-a50a-5c7d1b4a6e4b', 'fs-0477f58ff05019f73:/', '/efs-vols/grafana-db']' returned non-zero exit status 32. During handling of the above exception, another exception occurred: Traceback (most recent call last): File "/usr/sbin: unsuccessful EFS utils c

```
# github-actions-nanopb

Nanopb for GitHub Actions.

## Inputs

### `command`

**Required** Command to execute. Default `/nanopb/generator/nanopb_generator.py --version`.

## Example usage

```yaml
steps:
  - name: Retrieve runner uid and gid
    id: uid-gid
    run: |
      echo "uid=$(id -u)" >> $GITHUB_OUTPUT
      echo "gid=$(id -g)" >> $GITHUB_OUTPUT
  - name: compile example.proto
    uses: taichunmin/github-actions-nanopb@v1
    env:
      UID: ${{ steps.uid-gid.outputs.uid }}
      GID: ${{ steps.uid-gid.outputs.gid }}
    with:
      command: |
        /nanopb/generator/nanopb_generator.py example.proto
        chown $UID:$GID *.pb.h *.pb.c
```
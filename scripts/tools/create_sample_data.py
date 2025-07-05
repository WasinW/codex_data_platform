import pandas as pd
import sys
from pathlib import Path

output = Path(sys.argv[1])
output.mkdir(parents=True, exist_ok=True)

pdf = pd.DataFrame({'id': [1, 2, 3], 'value': ['a', 'b', 'c']})
pdf.to_parquet(output / 'part-0000.parquet')

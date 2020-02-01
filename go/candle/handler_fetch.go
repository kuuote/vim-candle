package candle

import (
	"context"
	"encoding/json"

	"github.com/sourcegraph/jsonrpc2"
)

func (h *Handler) HandleFetch(ctx context.Context, conn *jsonrpc2.Conn, req *jsonrpc2.Request) (interface{}, error) {
	var params FetchRequest
	if err := json.Unmarshal(*req.Params, &params); err != nil {
		h.Logger.Println(err)
		return nil, err
	}
	if h.Process != nil {
		return h.Process.Fetch(params)
	}
	return nil, nil
}


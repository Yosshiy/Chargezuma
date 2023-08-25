using UniRx;
using UnityEngine;

public class PlayerUsecase : MonoBehaviour
{
    IPlayerData Data = default;
    CompositeDisposable Disposable;

    public PlayerUsecase(IPlayerData data)
    {
        Data = data;
        Disposable = new CompositeDisposable();
    }


}

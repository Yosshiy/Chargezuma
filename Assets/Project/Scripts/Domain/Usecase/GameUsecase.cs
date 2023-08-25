using Chargezuma.Domain.Entity;
using UniRx;

namespace Chargezuma.Domain.Usecase
{
    public class GameUsecase : IGameUsecase
    {
        IGameEntity Entity = default;

        public GameUsecase(IGameEntity entity)
        {
            Entity = entity;
        }

        void IGameUsecase.GameModeChange(bool value)
        {
            Entity.GameModeChange(value);
        }

        IReactiveProperty<bool> IGameUsecase.GetGameMode()
        {
            return Entity.OnGameMode;
        }


    }
}
